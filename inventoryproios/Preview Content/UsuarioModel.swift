//
//  UsuarioModel.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

struct UsuarioModel: Identifiable {
    var id: String
    var nombres: String
    var apellidos: String
    var email: String
    var telefono: String
    var direccion: String
    var dui: String
    var fechaNacimiento: String
    var fechaCreacion: String
    var fotoURL: String
    var tipoPermiso: String
    var username: String
    var creadopor: String
    var estatus: String
}


//extension UsuarioModel: Hashable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    static func == (lhs: UsuarioModel, rhs: UsuarioModel) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
