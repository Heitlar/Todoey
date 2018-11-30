//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sergey Larkin on 2018/11/30.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Enter category name:", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let textField = alertController.textFields![0]
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveToDatabase()
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter category name here"
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - My methods

    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
            
        } catch {
            print("Error fetching request: \(error)")
        }
        tableView.reloadData()
        
    }

}
