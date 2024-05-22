//
//  SessionManager.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import FirebaseAuth
import FirebaseDatabase

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userPermissionType: String? = nil

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

    func fetchUserPermissionType() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("usuarios").child(userId).observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any],
               let permissionType = value["tipoPermiso"] as? String {
                DispatchQueue.main.async {
                    self.userPermissionType = permissionType
                }
            }
        }
    }
}
