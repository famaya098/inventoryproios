
//
//  ProductosScreen.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabaseInternal

struct ProductosScreen: View {
    @State private var codigo: String = generateUniqueCode()
    @State private var nombre: String = ""
    @State private var descripcion: String = ""
    @State private var precioCompra: String = ""
    @State private var precioVenta: String = ""
    @State private var cantidad: String = ""
    @State private var unidad: String = ""
    @State private var estatus: String = "Activo"
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false

    @State private var createdUser: String = ""
    
    var estatusOptions: [String] = ["Activo", "Inactivo", "Descontinuado"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Producto").font(.headline)) {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                        TextField("Código", text: $codigo)
                            .disabled(true)
                    }
                    HStack {
                        Image(systemName: "tag")
                        TextField("Nombre", text: $nombre)
                    }
                    HStack {
                        Image(systemName: "doc.text")
                        TextField("Descripción", text: $descripcion)
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
                        Image(systemName: "number")
                        TextField("Cantidad que Ingresa", text: $cantidad)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Image(systemName: "text.book.closed")
                        TextField("Unidad", text: $unidad)
                    }
                    Picker("Estatus", selection: $estatus) {
                        ForEach(estatusOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }

                Section(header: Text("Agregar Foto").font(.headline)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 150, height: 150)
                            .shadow(radius: 5)
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Seleccionar Foto")
                        }
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }
                }
                Section(header: Text("Creado por").font(.headline)) {
                                    Text(createdUser)
                                }




                Section {
                    Button(action: {
                        // Aquí colocar la lógica para guardar los datos
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
                   .onAppear {
                       loadCreatedUser()
                   }
               }

               private static func generateUniqueCode() -> String {
                   let uuid = UUID().uuidString
                   return uuid
               }
               
    private func loadCreatedUser() {
        guard let user = Auth.auth().currentUser else {
            // No hay usuario autenticado, establecer un valor predeterminado
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
           }
