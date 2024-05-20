//
//  ProductoModel.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import Foundation

struct ProductoModel: Identifiable {
    let id: String
    var nombre: String
    var codigo: String
    var descripcion: String
    var estatus: String
    var fechaCreacion: String
    var precioCompra: String
    var precioVenta: String
    var cantidad: String
    var unidad: String
    var photoURL: String
    var createdUser: String
}
