//
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
    @State private var producto: String = ""
    @State private var stock: Int = 0
    @State private var cantidad: Int = 0
    @State private var tipoTransaccion: String = "Entrada"
    @State private var totalDespuesTransaccion: Int = 0
    @State private var productNames: [String] = [] // Variable para almacenar los nombres de los productos
    
    // Función para generar un código único de transacción
    private static func generateUniqueTransactionCode() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    // Función para recuperar el stock del producto seleccionado desde Firebase
    private func getStockForProduct(productName: String) {
        let ref = Database.database().reference().child("productos")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let productosSnapshot = snapshot.value as? [String: [String: Any]] else {
                return
            }
            if let productData = productosSnapshot.first(where: { $0.value["nombre"] as? String == productName })?.value {
                if let stock = productData["cantidad"] as? Int {
                    self.stock = stock
                }
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
                    Picker("Producto", selection: $producto) {
                        ForEach(productNames, id: \.self) { productName in
                            Text(productName).tag(productName)
                        }
                    }
                    .onAppear {
                        getProductNamesFromFirebase() // Llama a la función para recuperar los nombres de los productos
                    }
                    .onChange(of: producto) { productName in
                        getStockForProduct(productName: productName) // Llama a la función para recuperar el stock del producto seleccionado
                    }
                    .keyboardType(.default)
                    Text("Stock: \(stock)") // Muestra el stock del producto seleccionado
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
