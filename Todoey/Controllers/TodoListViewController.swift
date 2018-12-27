//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Agnius Pazecka on 23/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
   
    var itemArray = [Item] ()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)

        loadItems()
        
// taking array from default location
//        if let array = defaults.array(forKey: "TodoListArray") as? [Item] {
//             itemArray = array
//        }
    }
    
    //MARK - tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItem", for: indexPath)
        
         let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        // ternary operator replaces code below
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
    
        return cell
        
    }
    
    //MARK - tableview delegate methods
    
    // checkmark functionality
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }
        //        else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
    }
    
    
    
    
    //MARK - Add new items
    
    @IBAction func AddNewItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New", style: .default) { (action) in
            // what will happen once user clics + on nav bar
            
            let newItem = Item()
            newItem.name = textField.text!
            self.itemArray.append(newItem)
            
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
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item arrray \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error during decoding \(error)")
            }
        
    }
    
}

}




