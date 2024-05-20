//
//  fetchUsuarios.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import FirebaseDatabase

func fetchUsuarios(completion: @escaping ([UsuarioModel]) -> Void) {
    var usuarios: [UsuarioModel] = []
    let ref = Database.database().reference().child("usuarios")
    
    ref.observeSingleEvent(of: .value) { snapshot in
        for child in snapshot.children {
            if let childSnapshot = child as? DataSnapshot,
               let dict = childSnapshot.value as? [String: Any],
               let nombres = dict["nombres"] as? String,
               let apellidos = dict["apellidos"] as? String,
               let email = dict["email"] as? String,
               let telefono = dict["telefono"] as? String,
               let direccion = dict["direccion"] as? String,
               let dui = dict["dui"] as? String,
               let fechaNacimiento = dict["fechaNacimiento"] as? String,
               let fechaCreacion = dict["fechaCreacion"] as? String,
               let fotoURL = dict["fotoURL"] as? String,
               let tipoPermiso = dict["tipoPermiso"] as? String,
               let username = dict["username"] as? String,
               let creadopor = dict["creadopor"] as? String,
               let estatus = dict["estatus"] as? String {
                
                let usuario = UsuarioModel(id: childSnapshot.key,
                                           nombres: nombres,
                                           apellidos: apellidos,
                                           email: email,
                                           telefono: telefono,
                                           direccion: direccion,
                                           dui: dui,
                                           fechaNacimiento: fechaNacimiento,
                                           fechaCreacion: fechaCreacion,
                                           fotoURL: fotoURL,
                                           tipoPermiso: tipoPermiso,
                                           username: username,
                                           creadopor: creadopor,
                                           estatus: estatus)
                usuarios.append(usuario)
            }
        }
        completion(usuarios)
    }
}
