//
//  ProductosScreen.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI

struct ProductosScreen: View {
    @State private var codigo: String = ""
    @State private var nombre: String = ""
    @State private var precioCompra: String = ""
    @State private var precioVenta: String = ""
    @State private var unidadSeleccionada: String = ""
    @State private var cantidad: String = ""

    var unidades: [String] = ["Unidad 1", "Unidad 2", "Unidad 3"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Producto").font(.headline)) {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                        TextField("Código", text: $codigo)
                    }
                    HStack {
                        Image(systemName: "tag")
                        TextField("Nombre", text: $nombre)
                    }
                }
                
                Section(header: Text("Detalles de la Compra").font(.headline)) {
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        TextField("Precio de Compra", text: $precioCompra)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        TextField("Precio de Venta", text: $precioVenta)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Image(systemName: "scalemass")
                        Picker("Unidad", selection: $unidadSeleccionada) {
                            ForEach(unidades, id: \.self) { unidad in
                                Text(unidad)
                            }
                        }
                    }
                    HStack {
                        Image(systemName: "number")
                        TextField("Cantidad de Unidades que Ingresa", text: $cantidad)
                            .keyboardType(.numberPad)
                    }
                }

                Section {
                    Button(action: {
                    
                    }) {
                        Text("Guardar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("Añadir Producto", displayMode: .inline)
        }
    }
}
