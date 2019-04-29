//
//  ViewController.swift
//  ToDo
//
//  Created by Vladimir Korolev on 26/04/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    private var itemArray = [Item]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    
    //MARK: - Controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true) //this line set cell to be instantly deselected after user has selected this cell
    }
    
    
    //MARK: - Button methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: -  CoreData methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}


//MARK: - Searchbar delegate methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //[cd] turns off case and diacritic sensitivity
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
