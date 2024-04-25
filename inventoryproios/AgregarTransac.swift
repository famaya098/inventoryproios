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
    @State private var productNames: [String] = [] // almacenar los nombres de los productos
    @State private var selectedProduct: String = "Seleccionar producto"
    @State private var stock: Int = 0
    
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
                    
                    DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                    // utiliza los nombres de los productos para inicializar el Picker
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

                    Text("Stock actual: \(stock)") // muestra el stock actual del producto seleccionado
                    
                    HStack {
                        Text("Cantidad de Entrada/Salida:")
                        Spacer()
                        TextField("Cantidad", text: Binding(
                            get: { "\(cantidad)" },
                            set: {
                                guard let value = Int($0) else { return }
                                cantidad = value
                            }
                        ))
                        .keyboardType(.numberPad)
                        .frame(width: 100)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    Picker("Tipo de Transacción", selection: $tipoTransaccion) {
                        Text("Entrada").tag("Entrada")
                        Text("Salida").tag("Salida")
                    }
                    Text("Total Stock Después de la Transacción: \(totalDespuesTransaccion)")
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
        }
    }
}
