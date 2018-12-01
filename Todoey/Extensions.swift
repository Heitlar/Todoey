//
//  Extensions.swift
//  Todoey
//
//  Created by Sergey Larkin on 2018/11/30.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

extension UITableViewController {
    
    func saveToRealm(category: Category? = nil, item: Item? = nil) {
        let realm = try! Realm()
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try realm.write {
                category != nil ? realm.add(category!) : realm.add(item!)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
   
    
}


