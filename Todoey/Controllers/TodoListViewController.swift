//
//  ViewController.swift
//  Todoey
//
//  Created by Sergey Larkin on 2018/11/17.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    //MARK: Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveToDatabase()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            saveToDatabase()
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add new list", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = alertController.textFields![0].text {
                
                
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                self.saveToDatabase()
            }
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Create new item"
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        
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
            print("Error fetching request: \(error)")
        }
        tableView.reloadData()

    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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


