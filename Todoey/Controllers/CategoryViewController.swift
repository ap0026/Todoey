//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Agnius Pazecka on 30/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching cattegoryArray \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New", style: .default) { (action) in
            // what will happen once user clics + on nav bar
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            self.categoryArray.append(newItem)
            
            //storing array to default location
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add text there"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    
    }
    
    
    
    
    
}
