//
//  fetchUsuarios.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import Firebase


func fetchUsuarios(completion: @escaping ([UsuarioModel]) -> Void) {
    let ref = Database.database().reference().child("usuarios")
    ref.observe(.value) { snapshot in
        var usuarios: [UsuarioModel] = []
        for child in snapshot.children {
            if let snap = child as? DataSnapshot,
               let value = snap.value as? [String: Any] {
                let id = snap.key
               let nombres = value["nombres"] as? String ?? ""
               let apellidos = value["apellidos"] as? String ?? ""
               let email = value["email"] as? String  ?? ""
               let telefono = value["telefono"] as? String  ?? ""
               let direccion = value["direccion"] as? String  ?? ""
               let dui = value["dui"] as? String  ?? ""
               let fechaNacimiento = value["fechaNacimiento"] as? String  ?? ""
               let fechaCreacion = value["fechaCreacion"] as? String  ?? ""
               let fotoURL = value["fotoURL"] as? String  ?? ""
               let tipoPermiso = value["tipoPermiso"] as? String  ?? ""
               let username = value["username"] as? String  ?? ""
               let creadopor = value["creadopor"] as? String  ?? ""
               let estatus = value["estatus"] as? String ?? ""
                
                let usuario = UsuarioModel(id: id,
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

