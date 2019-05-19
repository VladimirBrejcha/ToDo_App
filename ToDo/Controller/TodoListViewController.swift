//
//  ViewController.swift
//  ToDo
//
//  Created by Vladimir Korolev on 26/04/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
  
  private var todoItems: Results<Item>?
  
  private let realm = try! Realm()
  
  @IBOutlet weak var searchBar: UISearchBar!
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  
  //MARK: - Controller life cycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    title = selectedCategory?.name
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.tintColor = ContrastColorOf(backgroundColor: navigationBarTintColor!, returnFlat: true)
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: navigationBarTintColor!, returnFlat: true)]
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: navigationBarTintColor!, returnFlat: true)]
    searchBarSetup()
  }
  
  //MARK: UIsetup
  fileprivate func searchBarSetup() {
    searchBar.barTintColor = UIColor(hexString: selectedCategory?.backgroundColor)
    searchBar.backgroundColor = UIColor(hexString: selectedCategory?.backgroundColor)
    searchBar.tintColor = .white
    searchBar.showsCancelButton = false
    searchBar.setImage(UIImage(named: "Search Line"), for: .search, state: .normal)
  }
  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let item = todoItems?[indexPath.row] {
      cell.textLabel?.text = item.title
      if let color = UIColor(hexString: selectedCategory?.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
        cell.tintColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
      }
      cell.accessoryType = item.isDone ? .checkmark : .none
      
    } else {
      cell.textLabel?.text = "No tasks added"
    }
    
    return cell
  }
  
  //MARK: - TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = todoItems?[indexPath.row] {
      do {
        try realm.write {
          item.isDone = !item.isDone
        }
      } catch {
        print("error saving done status \(error)")
      }
    }
    
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true) //this line set cell to be instantly deselected after user has selected this cell
  }
  
  //MARK: - Button methods
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let action = UIAlertAction(title: "Add item", style: .default) { ( action ) in
      
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            currentCategory.items.append(newItem)
          }
        } catch {
          print("error saving item \(error)")
        }
      }
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
  }
  
  
  //MARK: -  Changing data methods
  private func loadItems() {
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
  }
  
  override func updateModel(at indexpath: IndexPath) {
    if let itemForDeletion = self.todoItems?[indexpath.row] {
      do {
        try self.realm.write {
          self.realm.delete(itemForDeletion)
        }
      } catch {
        print("Error deletng item \(error)")
      }
    }
  }
  
}

//MARK: - Searchbar delegate methods
extension TodoListViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
      
    }
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false
  }
  
}

extension TodoListViewController: NavigationBarColorable {
  public var navigationBarTintColor: UIColor? {
    return UIColor(hexString: selectedCategory?.backgroundColor)
  }
}

