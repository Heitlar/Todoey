//
//  Extensions.swift
//  Todoey
//
//  Created by Sergey Larkin on 2018/11/30.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import CoreData

extension UITableViewController {
    
    func saveToDatabase() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
}


