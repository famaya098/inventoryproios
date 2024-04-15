//
//  SessionManager.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import FirebaseAuth


class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "lastLoggedInEmail")
            isLoggedIn = false
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }

}
