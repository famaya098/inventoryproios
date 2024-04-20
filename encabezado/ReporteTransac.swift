//
//  ReporteTransac.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI

struct ReporteTransac: View {
    // Estructura para representar una transacción
    struct Transaccion: Identifiable {
        let id: String
        let cantidad: Int
        let codigoMedicamento: String
        let codigoTransaccion: String
        let createdDate: String
        let createdUser: String
        let fecha: String
        let medicamento: String
        let stock: Int
        let tipoTransaccion: String
        let imagen: String // Ruta de la imagen
    }
    
    // Lista de transacciones simuladas con información quemada
    let transacciones: [Transaccion] = [
        Transaccion(id: "-NvtoAHgQuFO6cCjHcGf", cantidad: 35, codigoMedicamento: "7155AEAE-6E38-4F31-9D01-C27DA3EACF3D", codigoTransaccion: "TRANS202404192242523737", createdDate: "19/04/2024", createdUser: "f.amaya", fecha: "19/04/2024", medicamento: "Televisor Samsung", stock: 100, tipoTransaccion: "Entrada", imagen: "television"),
        Transaccion(id: "-NvtoEjOXcY-JziCd5MO", cantidad: 38, codigoMedicamento: "FD8FDB83-5989-4945-835F-9C48D1936FE7", codigoTransaccion: "TRANS202404192243115098", createdDate: "19/04/2024", createdUser: "f.amaya", fecha: "19/04/2024", medicamento: "Celular Samsung", stock: 100, tipoTransaccion: "Salida", imagen: "chat"),
        Transaccion(id: "-NvtoIYTr9AAZUc_Fh8o", cantidad: 16, codigoMedicamento: "7155AEAE-6E38-4F31-9D01-C27DA3EACF3D", codigoTransaccion: "TRANS202404192243294069", createdDate: "19/04/2024", createdUser: "w.penado", fecha: "19/04/2024", medicamento: "Televisor Samsung", stock: 135, tipoTransaccion: "Salida", imagen: "television"),
        Transaccion(id: "-NvtoL2P-6GZw_hFXiXu", cantidad: 8, codigoMedicamento: "FD8FDB83-5989-4945-835F-9C48D1936FE7", codigoTransaccion: "TRANS20240419224344250", createdDate: "19/04/2024", createdUser: "f.amaya", fecha: "19/04/2024", medicamento: "Celular Samsung", stock: 62, tipoTransaccion: "Entrada", imagen: "chat")
    ]
    
    // Propiedades para la barra de búsqueda
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Text("Reporte de Transacciones")
                .font(.title)
                .foregroundColor(.black)
                .padding()
            
            HStack {
                TextField("Buscar en las Transacciones", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Acción del botón de búsqueda
                }) {
                    Text("Buscar")
                }
                .padding(.trailing)
                
                Button(action: {
                    // Acción del botón de imprimir
                }) {
                    Text("Imprimir")
                }
                .padding(.trailing)
            }
            
            List(transacciones.filter {
                searchText.isEmpty || $0.medicamento.localizedStandardContains(searchText)
            }, id: \.id) { transaccion in
                HStack {
                    Image(transaccion.imagen)
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading) {
                        //Text("Fecha: \(transaccion.fecha)")
                        Text("Producto: \(transaccion.medicamento)")
                            .font(.headline)
                        Text("Código Producto: \(transaccion.codigoMedicamento)")
                        Text("Código Transacción: \(transaccion.codigoTransaccion)")
                        Text("Cantidad: \(transaccion.cantidad)")
                        Text("Stock: \(transaccion.stock)")
                        Text("Tipo de Transacción: \(transaccion.tipoTransaccion)")
                        Text("Creado por: \(transaccion.createdUser)")
                        Text("Fecha de Creación: \(transaccion.createdDate)")
                    }
                    .padding(.vertical)
                }
            }
            
            Spacer()
        }
    }
}
