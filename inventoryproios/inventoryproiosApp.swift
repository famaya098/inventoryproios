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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            WelcomeScreenView()
                .environmentObject(appDelegate.sessionManager)
        }
    }
}
