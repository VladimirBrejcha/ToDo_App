//
//  AppDelegate.swift
//  ToDo
//
//  Created by Vladimir Korolev on 26/04/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //to check realm file path
    //print(Realm.Configuration.defaultConfiguration.fileURL)
    
    do {
      _ = try Realm() //initialising Realm
    } catch {
      print("error creating realm \(error)")
    }
    
    return true
  }
  
}

