//
//  ReporteTransac.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct TransaccionCardView: View {
    let transaccion: TransaccionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(transaccion.nombreProducto)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text("Código Transacción: \(transaccion.codigoTransaccion)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Cantidad: \(transaccion.cantidadIngresada)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Stock Inicial: \(transaccion.stockInicial)")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                
                Spacer()
                
                Text("Stock Final: \(transaccion.stockFinal)")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
            }
            
            HStack {
                Text("Tipo de Transacción: \(transaccion.tipoTransaccion)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Creado por: \(transaccion.creadoPor)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("Fecha de Creación: \(transaccion.fechaCreacion)")
                .font(.caption)
                .foregroundColor(.secondary)
                .bold()
            
            Divider()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct TransaccionSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Buscar transacción", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top, 8)
            Spacer()
        }
    }
}


struct ReporteTransacScreen: View {
    @State private var transacciones: [TransaccionModel] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TransaccionSearchBar(text: $searchText)
                    .padding(.horizontal)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(transacciones.filter {
                            searchText.isEmpty ? true : $0.nombreProducto.localizedCaseInsensitiveContains(searchText)
                        }) { transaccion in
                            TransaccionCardView(transaccion: transaccion)
                                .padding(.horizontal)
                        }
                    }
                }
                .navigationBarTitle("Listado Transacciones", displayMode: .inline)
                .navigationBarItems(trailing: HStack {
                    Button(action: {
                        printTransaccionList(transacciones)
                    }) {
                        Image(systemName: "printer")
                            .foregroundColor(.accentColor)
                    }
                })
            }
            .onAppear {
                fetchTransacciones { transacciones in
                    self.transacciones = transacciones
                }
            }
        }
    }
}

struct ReporteTransacScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReporteTransacScreen()
    }
}
