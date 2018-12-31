//
//  AppDelegate.swift
//  Todoey
//
//  Created by Agnius Pazecka on 23/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        //print("Realm location: \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        
        do {
            _ = try Realm()
            
        } catch {
            print("Error initializing Realm \(error)")
        }
        return true
    }

    

    
    




}

