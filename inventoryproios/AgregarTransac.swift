//  AgregarTransac.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct AgregarTransac: View {
    @State private var codigoTransaccion: String = generateUniqueTransactionCode()
    @State private var fecha: Date = Date()
    @State private var cantidad: String = ""
    @State private var tipoTransaccion: String = "Entrada"
    @State private var totalDespuesTransaccion: Int = 0
    @State private var productNames: [String] = [] // almacenar los nombres de los productos
    @State private var selectedProduct: String = "Seleccionar producto"
    @State private var stock: Int = 0
    @State private var createdUser: String = ""
    let transaccionesRef = Database.database().reference().child("transacciones")
    
    // generar un código único de transacción
    private static func generateUniqueTransactionCode() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    // recuperar los nombres de los productos desde Firebase
    private func getProductNamesFromFirebase() {
        let ref = Database.database().reference().child("productos")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let productosSnapshot = snapshot.value as? [String: [String: Any]] else {
                return
            }
            let nombres = productosSnapshot.compactMap { $0.value["nombre"] as? String }
            self.productNames = nombres
        }
    }
    
    // Función para cargar el nombre del usuario desde Firebase
        private func loadCreatedUser() {
            guard let user = Auth.auth().currentUser else {
                // Si no hay usuario autenticado, establecer un valor predeterminado
                createdUser = "Desconocido"
                return
            }

            // Obtener el nombre de usuario desde la base de datos en tiempo real de Firebase
            let databaseRef = Database.database().reference().child("usuarios").child(user.uid)
            databaseRef.observeSingleEvent(of: .value) { snapshot in
                if let userData = snapshot.value as? [String: Any],
                   let username = userData["username"] as? String {
                    self.createdUser = username
                } else {
                    self.createdUser = "Desconocido"
                }
            }
        }
    
    func formattedDate(date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .medium
           return formatter.string(from: date)
       }
    
    // Función para calcular el total de stock después de la transacción
        private func calcularTotalDespuesTransaccion() {
            guard let cantidadInt = Int(cantidad) else {
                totalDespuesTransaccion = 0
                return
            }
            
            if tipoTransaccion == "Entrada" {
                totalDespuesTransaccion = stock + cantidadInt
            } else {
                totalDespuesTransaccion = stock - cantidadInt
            }
        }
    
    private func getStockForSelectedProduct() {
        guard selectedProduct != "Seleccionar producto" else {
            stock = 0
            return
        }
        
        let ref = Database.database().reference().child("productos")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let productosSnapshot = snapshot.value as? [String: [String: Any]] else {
                return
            }
            
            for (productId, productData) in productosSnapshot {
                if let productName = productData["nombre"] as? String, productName == selectedProduct {
                    print("Datos del producto seleccionado: \(productData)")
                    
                    // Verifica si el campo cantidad existe y es un número
                    if let stockValue = productData["cantidad"] as? String, let stockInt = Int(stockValue) {
                        self.stock = stockInt
                        // Llama a la función para calcular el total después de actualizar el stock
                        calcularTotalDespuesTransaccion()
                        return
                    } else {
                        print("No se pudo obtener el stock del producto seleccionado")
                        self.stock = 0
                        return
                    }
                }
            }
            
            print("No se encontraron datos para el producto seleccionado")
            self.stock = 0
        }
    }

    
    

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Transacciones de Productos").font(.headline)) {
                    
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                        TextField("Código", text: $codigoTransaccion)
                            .disabled(true)
                    }
                    
                    HStack {
                                            Image(systemName: "calendar")
                                            Text("Fecha: \(formattedDate(date: fecha))")
                                        }
                    // utiliza los nombres de los productos para inicializar el Picker
                    Picker("Producto", selection: $selectedProduct) {
                        Text("Seleccionar producto").tag("Seleccionar producto")
                        ForEach(productNames, id: \.self) { productName in
                            Text(productName).tag(productName)
                        }
                    }
                    .onAppear {
                        getProductNamesFromFirebase()
                        getStockForSelectedProduct() // Llamar a la función en la carga inicial
                    }
                    .onChange(of: selectedProduct) { productName in
                        getStockForSelectedProduct() // Llamar a la función cuando se cambia el producto seleccionado
                    }
                    .keyboardType(.default)


                    Text("Stock actual: \(stock)")
                        .foregroundColor(stock > 0 ? .green : .red)
                     
                    
                    HStack {
                        Image(systemName: "number")
                        TextField("Cantidad", text: $cantidad)
                            .keyboardType(.numberPad)
                            .onChange(of: cantidad) { _ in
                                calcularTotalDespuesTransaccion()
                            }
                    }

                    Picker("Tipo de Transacción", selection: $tipoTransaccion) {
                        HStack {
                            if tipoTransaccion == "Entrada" {
                                Image(systemName: "arrow.down.circle.fill")
                            } else {
                                Image(systemName: "arrow.up.circle.fill")
                            }
                            Text("Entrada")
                        }
                        .tag("Entrada")

                        HStack {
                            if tipoTransaccion == "Salida" {
                                Image(systemName: "arrow.up.circle.fill")
                            } else {
                                Image(systemName: "arrow.down.circle.fill")
                            }
                            Text("Salida")
                        }
                        .tag("Salida")
                    }
                    .onChange(of: tipoTransaccion) { _ in
                        calcularTotalDespuesTransaccion()
                    }

                    
                    Text("Total Stock: \(cantidad.isEmpty ? stock : totalDespuesTransaccion)")
                        .foregroundColor(totalDespuesTransaccion >= 0 ? .black : .red)
                        .font(totalDespuesTransaccion >= 0 ? .body : .headline)
                        .fontWeight(totalDespuesTransaccion >= 0 ? .regular : .bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(totalDespuesTransaccion > 0 ? Color.green : (totalDespuesTransaccion == 0 ? Color.black : Color.red), lineWidth: 2)
                        )


                        .frame(maxWidth: .infinity)

                }
                Section(header: Text("Creado por").font(.headline)) {
                                    Text(createdUser)
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
            .navigationBarTitle("Agregar Transacción", displayMode: .inline)
                        .onAppear {
                            loadCreatedUser() // Cargar el nombre del usuario cuando la vista aparece
                        }
        }
    }
}
