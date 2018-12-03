//
//  ViewController.swift
//  Todoey
//
//  Created by Sergey Larkin on 2018/11/17.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    //MARK: Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do  {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Eror updating item \(error)")
            }
        }
        
        //        try! realm.write {
        //            todoItems![indexPath.row].done = !todoItems![indexPath.row].done
        //        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            try! realm.write {
                realm.delete(todoItems![indexPath.row])
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add new list", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let text = alertController.textFields![0].text {
                
                let newItem = Item()
                newItem.title = text
                print(newItem.date)
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new Item: \(error)")
                    }
                }
                
                
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { (textField) in
            textField.placeholder = "Create new item"
        }
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        todoItems = selectedCategory?.items.filter("title CONTAINS[cd] '\(searchBar.text!)'").sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


