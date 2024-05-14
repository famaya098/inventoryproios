//
//  fetchTransacciones.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import Foundation
import Firebase
import FirebaseDatabaseInternal

func fetchTransacciones(completion: @escaping ([TransaccionModel]) -> Void) {
    let ref = Database.database().reference().child("transacciones")
    ref.observe(.value) { snapshot in
        var tempTransacciones: [TransaccionModel] = []
        for child in snapshot.children {
            if let snap = child as? DataSnapshot,
               let value = snap.value as? [String: Any] {
                let id = snap.key
                let cantidadIngresada = value["cantidadIngresada"] as? String ?? ""
                let codigoTransaccion = value["codigoTransaccion"] as? String ?? ""
                let creadoPor = value["creadoPor"] as? String ?? ""
                let fechaCreacion = value["fechaCreacion"] as? String ?? ""
                let nombreProducto = value["nombreProducto"] as? String ?? ""
                let stockFinal = value["stockFinal"] as? String ?? ""
                let stockInicial = value["stockInicial"] as? String ?? ""
                let tipoTransaccion = value["tipoTransaccion"] as? String ?? ""
                
                let transaccion = TransaccionModel(
                    id: id,
                    cantidadIngresada: cantidadIngresada,
                    codigoTransaccion: codigoTransaccion,
                    creadoPor: creadoPor,
                    fechaCreacion: fechaCreacion,
                    nombreProducto: nombreProducto,
                    stockFinal: stockFinal,
                    stockInicial: stockInicial,
                    tipoTransaccion: tipoTransaccion
                )
                tempTransacciones.append(transaccion)
            }
        }
        completion(tempTransacciones)
    }
}
