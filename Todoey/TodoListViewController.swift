//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Agnius Pazecka on 23/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mikey", "Get some Eggos", "Defeat Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // taking array from default location
        if let array = defaults.array(forKey: "TodoListArray") as? [String] {
             itemArray = array
        }
    }
    
    //MARK - tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItem", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    //MARK - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    //MARK - Add new items
    
    @IBAction func AddNewItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New", style: .default) { (action) in
            // what will happen once user clics + on nav bar
            self.itemArray.append(textField.text!)
            
            //storing array to default location
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add text there"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
        
        
    }
}






