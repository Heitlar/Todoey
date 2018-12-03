//
//  AppDelegate.swift
//  Todoey
//
//  Created by Sergey Larkin on 2018/11/17.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            print("Error creating Realm Database \(error)")
        }
    
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

