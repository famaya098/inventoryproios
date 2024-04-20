//  AgregarTransac.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//


import SwiftUI
import FirebaseDatabase

struct AgregarTransac: View {
    @State private var codigoTransaccion: String = generateUniqueTransactionCode()
    @State private var fecha: Date = Date()
    @State private var cantidad: Int = 0
    @State private var tipoTransaccion: String = "Entrada"
    @State private var totalDespuesTransaccion: Int = 0
    @State private var productNames: [String] = [] // Variable para almacenar los nombres de los productos
    @State private var selectedProduct: String = "Seleccionar producto"
    @State private var stock: Int = 0 // Stock del producto seleccionado
    
    // Función para generar un código único de transacción
    private static func generateUniqueTransactionCode() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    // Función para recuperar los nombres de los productos desde Firebase
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
    
    private func getStockForSelectedProduct() {
        guard selectedProduct != "Seleccionar producto" else {
            stock = 0
            return
        }
        
        let ref = Database.database().reference().child("productos").child(selectedProduct)
        ref.observeSingleEvent(of: .value) { snapshot in
            if let productData = snapshot.value as? [String: Any] {
                print("Datos del producto seleccionado: \(productData)")
                
                // Verifica si el campo "cantidad" existe y es un número
                if let stockValue = productData["cantidad"] as? String, let stockInt = Int(stockValue) {
                    self.stock = stockInt
                } else {
                    print("No se pudo obtener el stock del producto seleccionado")
                    self.stock = 0
                }
            } else {
                print("No se encontraron datos para el producto seleccionado")
                self.stock = 0
            }
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
                    
                    DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                    // Utiliza los nombres de los productos para inicializar el Picker
                    Picker("Producto", selection: $selectedProduct) {
                        Text("Seleccionar producto").tag("Seleccionar producto")
                        ForEach(productNames, id: \.self) { productName in
                            Text(productName).tag(productName)
                        }
                    }
                    .onAppear {
                        getProductNamesFromFirebase()
                    }
                    .onChange(of: selectedProduct) { productName in
                        getStockForSelectedProduct()
                    }
                    .keyboardType(.default)

                    
                    Text("Stock actual: \(stock)") // Muestra el stock actual del producto seleccionado
                    
                    Stepper(value: $cantidad, in: 0...Int.max, label: {
                        Text("Cantidad de Entrada/Salida: \(cantidad)")
                    })
                    Picker("Tipo de Transacción", selection: $tipoTransaccion) {
                        Text("Entrada").tag("Entrada")
                        Text("Salida").tag("Salida")
                    }
                    Text("Total Stock Después de la Transacción: \(totalDespuesTransaccion)")
                }
                
                Section {
                    Button(action: {
                        // Lógica para guardar la transacción
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
        }
    }
}

