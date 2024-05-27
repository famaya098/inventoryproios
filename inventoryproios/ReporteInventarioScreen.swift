//
//  ReporteInventarioScreen.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCardView: View {
    let producto: ProductoModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WebImage(url: URL(string: producto.photoURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
            
            Text(producto.nombre)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(producto.descripcion)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("Código: \(producto.codigo)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Stock: \(producto.cantidad)")
                    .font(.headline)
                    .foregroundColor(producto.cantidad == "0" ? .red : .green)
            }
            
            HStack {
                Text("Precio compra: $\(producto.precioCompra)")
                    .font(.caption)
                    .foregroundColor(.black)
                    .bold()
                
                Spacer()
                
                Text("Precio venta: $\(producto.precioVenta)")
                    .font(.caption)
                    .foregroundColor(.black)
                    .bold()
            }
            
            Divider()
            
            HStack {
                Text("Unidad: \(producto.unidad)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Creado por: \(producto.createdUser)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct ProductSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Buscar producto", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top, 8)
            Spacer()
        }
    }
}

struct ReporteInventarioScreen: View {
    @State private var productos: [ProductoModel] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ProductSearchBar(text: $searchText)
                    .padding(.horizontal)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(productos.filter {
                            searchText.isEmpty ? true : $0.nombre.localizedCaseInsensitiveContains(searchText)
                        }) { producto in
                            ProductCardView(producto: producto)
                                .padding(.horizontal)
                        }
                    }
                }
                .navigationBarTitle("Stock Productos", displayMode: .inline)
                .navigationBarItems(trailing: HStack {
                    NavigationLink(destination: ProductosScreen()) {
                        Image(systemName: "plus")
                            .foregroundColor(.accentColor)
                    }
                    Button(action: {
                        printProductList(productos)
                    }) {
                        Image(systemName: "printer")
                            .foregroundColor(.accentColor)
                    }
                })

            }
            .onAppear {
                fetchProductos { productos in
                    self.productos = productos
                }
            }
        }
    }
}

struct ReporteInventarioScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReporteInventarioScreen()
    }
}
