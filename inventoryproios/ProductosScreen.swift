
//
//  ProductosScreen.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabaseInternal
import FirebaseStorage

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
    
    @State private var fechaCreacion = Date()
    @State private var alertMessage: AlertMessage?
    @State private var showAlert = false

    
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
                    HStack {
                                            Image(systemName: "calendar")
                                            Text("Fecha: \(formattedDate(date: fechaCreacion))")
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
                        saveProduct()
                    }) {
                        Text("Guardar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .alert(isPresented: $showAlert) {
                    if let alertMessage = alertMessage {
                        return Alert(
                            title: Text(alertMessage.title),
                            message: Text(alertMessage.message),
                            dismissButton: .default(Text("OK")) {
                                handleAlertDismissed()
                            }
                        )
                    } else {
                        return Alert(title: Text("Error"), message: Text("Se ha producido un error"), dismissButton: .default(Text("OK")))
                    }
                }

            }
            .navigationBarTitle("Añadir Producto", displayMode: .inline)
                   }
                   .onAppear {
                       fechaCreacion = Date()
                       loadCreatedUser()
                   }
               }

               private static func generateUniqueCode() -> String {
                   let uuid = UUID().uuidString
                   return uuid
               }
    
        // Función para mostrar la alerta
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    
        struct AlertMessage {
            var title: String
            var message: String
        }
        
        func handleAlertDismissed() {
            self.alertMessage = nil
        }


    
    func formattedDate(date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .medium
           return formatter.string(from: date)
       }
    
    private func loadCreatedUser() {
        guard let user = Auth.auth().currentUser else {
            // no hay usuario autenticado, establecer un valor predeterminado
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

                // Guardar el producto en Firebase Realtime Database y la foto en Firebase Storage
    private func saveProduct() {
        // Verificar que los campos obligatorios no estén vacíos
        guard !nombre.isEmpty && !descripcion.isEmpty && !precioCompra.isEmpty && !precioVenta.isEmpty && !cantidad.isEmpty && !unidad.isEmpty else {
                // Mostrar una alerta al usuario
                self.alertMessage = AlertMessage(title: "Error", message: "Todos los campos son obligatorios. Asegúrate de completarlos antes de guardar.")
                self.showAlert = true
                return
            }

                    // Obtener una referencia a la base de datos y a Storage
                    let dbRef = Database.database().reference()
                    let storageRef = Storage.storage().reference()

                    // Generar un nombre único para la imagen en Storage
                    let imageRef = storageRef.child("productos/\(codigo).jpg")

                    // Comprimir y subir la imagen seleccionada a Storage
                    if let imageData = selectedImage?.jpegData(compressionQuality: 0.5) {
                        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                            if let error = error {
                                print("Error al subir la imagen a Firebase Storage: \(error.localizedDescription)")
                                // Manejar el error
                            } else {
                                // Obtener la URL de descarga de la imagen
                                imageRef.downloadURL { (url, error) in
                                    if let error = error {
                                        print("Error al obtener la URL de descarga de la imagen: \(error.localizedDescription)")
                                        // Manejar el error
                                    } else if let downloadURL = url {
                                        // Guardar los datos del producto en la base de datos
                                        let productData: [String: Any] = [
                                            "codigo": codigo,
                                            "nombre": nombre,
                                            "descripcion": descripcion,
                                            "precioCompra": precioCompra,
                                            "precioVenta": precioVenta,
                                            "cantidad": cantidad,
                                            "unidad": unidad,
                                            "estatus": estatus,
                                            "createdUser": createdUser,
                                            "fechaCreacion": formattedDate(date: fechaCreacion),
                                            "photoURL": downloadURL.absoluteString
                                                                        ]

                                        // Guardar los datos del producto en la base de datos
                                        dbRef.child("productos").child(codigo).setValue(productData) { (error, ref) in
                                            if let error = error {
                                                print("Error al guardar los datos del producto en Firebase Realtime Database: \(error.localizedDescription)")
                                                
                                            } else {
                                                print("Producto guardado exitosamente en Firebase Realtime Database")
                                                
                                                clearFields()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        
                        print("No se ha seleccionado ninguna imagen")
                    }
                }

    
                private func clearFields() {
                    nombre = ""
                    descripcion = ""
                    precioCompra = ""
                    precioVenta = ""
                    cantidad = ""
                    unidad = ""
                    estatus = "Activo"
                    selectedImage = nil
                    codigo = ProductosScreen.generateUniqueCode()
                    fechaCreacion = Date()
                }
            }
