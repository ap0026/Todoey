//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Agnius Pazecka on 30/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let category = categories?[indexPath.row] else { fatalError() }
        guard let categoryColour = UIColor(hexString: category.colour) else { fatalError() }
        cell.textLabel?.text = category.name
        cell.backgroundColor = categoryColour
        cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
//        cell.delegate = self
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
        tableView.rowHeight = 80.0
    }
    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryFordeletion = categories?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(categoryFordeletion)
                }
            } catch {
                print("Error during category deletion \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New", style: .default) { (action) in
            // what will happen once user clics + on nav bar
            
            let newItem = Category()
            newItem.name = textField.text!
            newItem.colour = UIColor.randomFlat.hexValue()
            
            //storing array to default location
            //self.defaults.set(self.todoItems, forKey: "TodoListArray")
            
            self.save(category: newItem)
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add text there"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    
    }
    
    
    
    
    
}

