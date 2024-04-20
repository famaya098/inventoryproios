//
//  DetalleProducto.swift
//  inventoryproios
//
//  Created by Administrador on 19/4/24.
//

// DetalleProducto.swift

import SwiftUI

import SwiftUI

struct DetalleProductoScreen: View {
    @State private var codigo: String = "7155AEAE-6E38-4F31-9D01-C27DA3EACF3D"
    @State private var nombre: String = "Televisor Samsung"
    @State private var precioCompra: String = "300"
    @State private var precioVenta: String = "450"
    @State private var unidad: String = "Cajas"
    @State private var cantidad: String = "100"

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("DATOS DEL MEDICAMENTO")
                    .font(.title)
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Código:")
                    TextField("Código", text: $codigo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Nombre:")
                    TextField("Nombre", text: $nombre)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Precio de Compra:")
                    TextField("Precio de Compra", text: $precioCompra)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Precio de Venta:")
                    TextField("Precio de Venta", text: $precioVenta)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Unidad:")
                    TextField("Unidad", text: $unidad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Cantidad en Stock:")
                    TextField("Cantidad en Stock", text: $cantidad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }

                Button(action: {
                    // Acción de guardar
                }) {
                    Text("Guardar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    // Acción de eliminar
                }) {
                    Text("Eliminar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    // Acción de regresar
                }) {
                    Text("Regresar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color(hex: 0x18232D))
        .navigationBarTitle("Editar Medicamento", displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DetalleProductoScreen()
    }
}
