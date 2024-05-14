//
//  fetchProductos.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import Foundation
import Firebase
import FirebaseDatabaseInternal

func fetchProductos(completion: @escaping ([ProductoModel]) -> Void) {
    let ref = Database.database().reference().child("productos")
    ref.observe(.value) { snapshot in
        var tempProductos: [ProductoModel] = []
        for child in snapshot.children {
            if let snap = child as? DataSnapshot,
               let value = snap.value as? [String: Any] {
                let id = snap.key
                let nombre = value["nombre"] as? String ?? ""
                let codigo = value["codigo"] as? String ?? ""
                let descripcion = value["descripcion"] as? String ?? ""
                let estatus = value["estatus"] as? String ?? ""
                let fechaCreacion = value["fechaCreacion"] as? String ?? ""
                let precioCompra = value["precioCompra"] as? String ?? ""
                let precioVenta = value["precioVenta"] as? String ?? ""
                let cantidad = value["cantidad"] as? String ?? ""
                let unidad = value["unidad"] as? String ?? ""
                let photoURL = value["photoURL"] as? String ?? ""
                let createdUser = value["createdUser"] as? String ?? ""
                
                let producto = ProductoModel(id: id, nombre: nombre, codigo: codigo, descripcion: descripcion, estatus: estatus, fechaCreacion: fechaCreacion, precioCompra: precioCompra, precioVenta: precioVenta, cantidad: cantidad, unidad: unidad, photoURL: photoURL, createdUser: createdUser)
                tempProductos.append(producto)
            }
        }
        completion(tempProductos)
    }
}
