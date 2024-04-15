//
//  SessionManager.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "lastLoggedInEmail")
            isLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
