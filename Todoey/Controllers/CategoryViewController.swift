//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sergey Larkin on 2018/11/30.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Enter category name:", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let textField = alertController.textFields![0]
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter category name here"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - My methods
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
                                
            }
        } catch {
            print("Error saving category: \(error)")
        }
    }

}
