//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Vladimir Korolev on 29/04/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    private var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
    }
    
    //MARK: - TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].backgroundColor) ?? .white
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categores added yet"
        return cell
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewConroller = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewConroller.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Data manipulation methods
    func loadCategory() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexpath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexpath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deletng category \(error)")
            }
        }
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.backgroundColor = UIColor.randomFlat().hexValue()
            print(newCategory.backgroundColor)
            self.saveCategory(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Category name"
        }
        
        present(alert, animated: true, completion: nil)
    }
}


