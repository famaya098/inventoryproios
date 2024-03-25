//
//  inventoryproiosApp.swift
//  inventoryproios
//
//  Created by Administrador on 24/3/24.
//

import SwiftUI
import Firebase

@main
struct inventoryproiosApp: App {
    var body: some Scene {
        WindowGroup {
            
            WelcomeScreenView()
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
