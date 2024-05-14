//
//  ProductoModel.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import Foundation

struct ProductoModel: Identifiable {
    let id: String
    let nombre: String
    let codigo: String
    let descripcion: String
    let estatus: String
    let fechaCreacion: String
    let precioCompra: String
    let precioVenta: String
    let cantidad: String
    let unidad: String
    let photoURL: String
    let createdUser: String
}
