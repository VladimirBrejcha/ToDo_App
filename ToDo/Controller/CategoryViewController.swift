//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Vladimir Korolev on 29/04/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    private var categoryArray = [Category]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewConroller = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewConroller.selectedCategory = categoryArray[indexPath.row]
        }
    }
    //MARK: - Data manipulation methods
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error \(error)")
        }
        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
