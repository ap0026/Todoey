//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Agnius Pazecka on 23/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let stringColour = selectedCategory?.colour else {fatalError("fatal error selected category")}
            
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller nor exist")
            }
        guard let navBarColour = UIColor(hexString: stringColour) else {fatalError("fatal error colour is nil")}
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.barTintColor = navBarColour
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                searchBar.barTintColor = navBarColour
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalBarColour = UIColor(hexString: "1D9BF6") else {
            fatalError("original bar colour is nil")
        }
        navigationController?.navigationBar.barTintColor = originalBarColour
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
    }
    
    //MARK: - tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row] {

        cell.textLabel?.text = item.name
            
            let cellBackgroundColor = UIColor(hexString: selectedCategory!.colour)
            let darkenGradient = CGFloat(indexPath.row) / CGFloat(todoItems!.count)
                cell.backgroundColor = cellBackgroundColor?.darken(byPercentage: darkenGradient)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        // ternary operator replaces code below
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        //        if todoItems[indexPath.row].done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }

        return cell

    }

    //MARK: - tableview delegate methods
    
    // checkmark functionality
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error selecting item \(item)")
            }
        }
//        todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done
//
//        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }
        //        else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
    }
    
    //MARK: - Add new items
    
    @IBAction func AddNewItemPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New", style: .default) { (action) in
            // what will happen once user clics + on nav bar

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.name = textField.text!
                    newItem.dateCreated = NSDate()
                    currentCategory.items.append(newItem)
                }
                
                } catch {
                    print("Errror saving todo item \(error)")
                }
            }
        self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add text there"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true)
    }

    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)

        tableView.reloadData()
    }

    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let todoItemForDeletion = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(todoItemForDeletion)
                }
            } catch {
                print("Error during category deletion \(error)")
            }
        }
    }
}



//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // dismisses keyboard and cursor

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}




