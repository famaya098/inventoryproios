//
//  AppDelegate.swift
//  inventoryproios
//
//  Created by Administrador on 24/3/24.
//

import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    var sessionManager = SessionManager()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
