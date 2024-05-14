//
//  TransaccionModel.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import Foundation

struct TransaccionModel: Identifiable {
    let id: String
    let cantidadIngresada: String
    let codigoTransaccion: String
    let creadoPor: String
    let fechaCreacion: String
    let nombreProducto: String
    let stockFinal: String
    let stockInicial: String
    let tipoTransaccion: String
}
