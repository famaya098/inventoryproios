//
//  CreacionUsuarios.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreInternal

import FirebaseStorage
import FirebaseDatabaseInternal


struct AlertMessage {
    var title: String
    var message: String
}

struct CreacionUsuarios: View {
    @State private var nombres: String = ""
    @State private var apellidos: String = ""
    @State private var email: String = ""
    @State private var contrasena: String = ""
    @State private var dui: String = ""
    @State private var username: String = ""
    @State private var tipoPermiso: String = "Administrador"
    @State private var telefono: String = ""
    @State private var direccion: String = ""
    @State private var fechaNacimiento: Date = Date()
    @State private var foto: UIImage? = nil
    
    @State private var fechaActualizacion: Date = Date()
    @State private var estatus: String = "Activo"
    @State private var creadopor: String = ""

    let fechaCreacion = Date()
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage? = nil

    // Firebase Authentication
      //@State private var signUpError: Error?
      //@State private var isLoggedIn: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var alertMessage: AlertMessage?
    @State private var showAlert = false
    @State private var showSuccessNotification = false
    
    

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información Personal").font(.headline)) {
                    HStack {
                        Image(systemName: "person.fill")
                        TextField("Nombres", text: $nombres)
                    }
                    HStack {
                        Image(systemName: "person.fill")
                        TextField("Apellidos", text: $apellidos)
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                        TextField("Email", text: $email)
                    }
                    HStack {
                        Image(systemName: "lock.fill")
                        SecureField("Contraseña", text: $contrasena)
                    }
                    HStack {
                        Image(systemName: "number.square.fill")
                        TextField("DUI", text: $dui)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Image(systemName: "person.crop.rectangle.fill")
                        TextField("Username", text: $username)
                    }
                    HStack {
                        Image(systemName: "phone.fill")
                        TextField("Teléfono", text: $telefono)
                            .keyboardType(.phonePad)
                    }
                    HStack {
                        Image(systemName: "house.fill")
                        TextField("Dirección", text: $direccion)
                    }
                    DatePicker("Fecha Nacimiento", selection: $fechaNacimiento, in: ...Date(), displayedComponents: .date)
                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Seleccionar Foto")
                        }
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: self.$selectedImage)
                    }
                }
                Section(header: Text("Información del Sistema").font(.headline)) {
                    Text("Fecha Creación: \(formattedDate(date: fechaCreacion))")
                                       
                    Picker("Tipo Permiso", selection: $tipoPermiso) {
                                           Text("Administrador").tag("Administrador")
                                           Text("Usuario").tag("Usuario")
                                       }
                    Picker("Estatus", selection: $estatus) {
                                           Text("Activo").tag("Activo")
                                           Text("Inactivo").tag("Inactivo")
                                       }
                    HStack {
                        Image(systemName: "person.crop.rectangle.fill")
                        TextField("Creado por", text: $creadopor)
                    }
                }
                Section {
                    Button(action: {
                    signUp()
                        
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
            .navigationBarTitle("Crear Usuario", displayMode: .inline)
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
    
    func clearFields() {
        nombres = ""
        apellidos = ""
        email = ""
        contrasena = ""
        dui = ""
        username = ""
        tipoPermiso = "Administrador"
        telefono = ""
        direccion = ""
        fechaNacimiento = Date()
        foto = nil
        fechaActualizacion = Date()
        estatus = "Activo"
        creadopor = ""
    }
       
//
    func signUp() {
        
        guard !email.isEmpty && !contrasena.isEmpty && !nombres.isEmpty && !apellidos.isEmpty && !dui.isEmpty && !username.isEmpty && !tipoPermiso.isEmpty && !telefono.isEmpty && !direccion.isEmpty  else {
            
            self.alertMessage = AlertMessage(title: "Error", message: "Todos los campos son obligatorios, Asegurate que no falte ninguno")
            self.showAlert = true
            print("Error: Campos vacíos")
            return
        }

        print("Todos los campos están completos. Continuando con el registro...")

        Auth.auth().createUser(withEmail: email, password: contrasena) { authResult, error in
            if let error = error {
                
                self.alertMessage = AlertMessage(title: "Error", message: "Error al registrar usuario: \(error.localizedDescription)")
                self.showAlert = true
                print("Error al registrar usuario:", error.localizedDescription)
            } else {
                
                self.alertMessage = AlertMessage(title: "Genial!", message: "\(username) ha sido creado con éxito.")
                self.showAlert = true
                saveUserData()
                clearFields()
                print("Usuario registrado exitosamente.")
            }
        }
    }






       
       func saveUserData() {
           guard let uid = Auth.auth().currentUser?.uid else {
               
               return
           }
           
           let db = Database.database().reference()
           let userData: [String: Any] = [
               "nombres": nombres,
               "apellidos": apellidos,
               "email": email,
               "dui": dui,
               "username": username,
               "tipoPermiso": tipoPermiso,
               "telefono": telefono,
               "direccion": direccion,
               "fechaNacimiento": formattedDate(date: fechaNacimiento),
               "fechaCreacion": formattedDate(date: fechaCreacion),
               "estatus": estatus,
               "creadopor": creadopor
           ]
           
           db.child("usuarios").child(uid).setValue(userData) { error, ref in
               if let error = error {
                   
                   print("Error al guardar datos del usuario en Realtime Database: \(error.localizedDescription)")
               } else {
                   
                   print("Datos del usuario guardados exitosamente en Realtime Database")
                   
                   
                   if let image = selectedImage {
                       uploadPhoto(uid: uid, image: image)
                   } else {
                       
                       //presentationMode.wrappedValue.dismiss()
                      
                   }
               }
           }
       }
       
       func uploadPhoto(uid: String, image: UIImage) {
           guard let imageData = image.jpegData(compressionQuality: 0.5) else {
               
               return
           }
           
           let storageRef = Storage.storage().reference().child("usuarios/\(uid).jpg")
           
           storageRef.putData(imageData, metadata: nil) { metadata, error in
               if let error = error {
                   
                   print("Error al subir la imagen a Firebase Storage: \(error.localizedDescription)")
               } else {
                  
                   storageRef.downloadURL { url, error in
                       if let error = error {
                           
                           print("Error al obtener la URL de descarga de la imagen: \(error.localizedDescription)")
                       } else if let url = url {
                           
                           updatePhotoURL(uid: uid, url: url.absoluteString)
                       }
                   }
               }
           }
       }
       
       func updatePhotoURL(uid: String, url: String) {
           let db = Database.database().reference()
           let userRef = db.child("usuarios").child(uid)
           
           userRef.updateChildValues(["fotoURL": url]) { error, ref in
               if let error = error {
                  
                   print("Error al actualizar la URL de la foto en Realtime Database: \(error.localizedDescription)")
               } else {
                   
                   print("URL de la foto actualizada exitosamente en Realtime Database")
                   
                   //presentationMode.wrappedValue.dismiss()
               }
           }
       }
   }
