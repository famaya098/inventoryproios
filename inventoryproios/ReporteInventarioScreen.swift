//
//  ReporteInventarioScreen.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI

struct ReporteInventarioScreen: View {
    // Estructura para representar un producto
    struct Producto {
        let nombre: String
        let codigo: String
        let precioCompra: String
        let precioVenta: String
        let stock: String
        let unidad: String
        let photoURL: String
    }
    
    // Lista de productos simulados con información quemada
    let productos: [Producto] = [
        Producto(nombre: "Televisor Samsung", codigo: "7155AEAE-6E38-4F31-9D01-C27DA3EACF3D", precioCompra: "$300", precioVenta: "$450", stock: "100", unidad: "Cajas", photoURL: "television"),
        Producto(nombre: "Celular Samsung", codigo: "FD8FDB83-5989-4945-835F-9C48D1936FE7", precioCompra: "$999", precioVenta: "$1499", stock: "100", unidad: "Cajas", photoURL: "chat")
    ]
    
    // Propiedades para la barra de búsqueda
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Text("Productos")
                .font(.title)
                .foregroundColor(.black)
                .padding()
            
            HStack {
                TextField("Buscar en el Stock", text: $searchText)
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
                    Text("Agregar (+)")
                }
                .padding(.trailing)
            }
            
            List(productos.filter {
                searchText.isEmpty || $0.nombre.localizedStandardContains(searchText)
            }, id: \.codigo) { producto in
                VStack(alignment: .leading) {
                    Image(producto.photoURL)
                        .resizable()
                        .frame(width: 96, height: 96)
                        .padding()
                    
                    Text(producto.nombre)
                        .font(.headline)
                    
                    Text("Código: \(producto.codigo)")
                    Text("Precio Compra: \(producto.precioCompra)")
                    Text("Precio Venta: \(producto.precioVenta)")
                    Text("Stock: \(producto.stock)")
                    Text("Unidad: \(producto.unidad)")
                }
            }
            
            Spacer()
        }
    }
}
