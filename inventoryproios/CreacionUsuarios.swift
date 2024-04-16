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

struct CreacionUsuarios: View {
    @State private var nombres: String = ""
    @State private var apellidos: String = ""
    @State private var email: String = ""
    @State private var contrasena: String = ""
    @State private var dui: String = ""
    @State private var username: String = ""
    @State private var tipoPermiso: String = ""
    @State private var telefono: String = ""
    @State private var direccion: String = ""
    @State private var fechaNacimiento: Date = Date()
    @State private var foto: UIImage? = nil
    
    @State private var fechaActualizacion: Date = Date()
    @State private var estatus: String = ""
    @State private var creadopor: String = ""

    let fechaCreacion = Date()
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage? = nil

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
                        guardarUsuarioEnFirebase()
                        
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
                    }
                }
                
            
    func formattedDate(date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .medium
           return formatter.string(from: date)
       }
       
       //guardar el usuario en Firebase
       func guardarUsuarioEnFirebase() {
           // uid único para el usuario
           let uid = UUID().uuidString
           
           // referencia a la base de datos de Firebase
           let db = Firestore.firestore()
           
           // diccionario con los datos del usuario
           var usuarioData: [String: Any] = [
               "uid": uid,
               "nombres": nombres,
               "apellidos": apellidos,
               "email": email,
               "dui": dui,
               "username": username,
               "tipoPermiso": tipoPermiso,
               "telefono": telefono,
               "direccion": direccion,
               "fechaNacimiento": fechaNacimiento,
               "fechaCreacion": fechaCreacion,
               "fechaActualizacion": fechaActualizacion,
               "estatus": estatus,
               "creadopor": creadopor
               // Agrega otros campos si los necesitas
           ]
           
           // foto a Firebase Storage si está seleccionada
           if let foto = foto {
               guardarFotoEnFirebase(foto, uid: uid)
           }
           
           // usuario a la colección "usuarios" en Firebase
           db.collection("usuarios").document(uid).setData(usuarioData) { error in
               if let error = error {
                   print("Error al guardar el usuario: \(error.localizedDescription)")
               } else {
                   print("Usuario guardado exitosamente")
                   
                   // crear el usuario en la autenticación de Firebase
                   Auth.auth().createUser(withEmail: email, password: contrasena) { authResult, error in
                       if let error = error {
                           print("Error al crear el usuario en la autenticación de Firebase: \(error.localizedDescription)")
                       } else {
                           print("Usuario creado exitosamente en la autenticación de Firebase")
                       }
                   }
               }
           }
       }
       
       // guardar la foto en Firebase Storage
       func guardarFotoEnFirebase(_ foto: UIImage, uid: String) {
           // Convertir la imagen en datos JPEG
           guard let fotoData = foto.jpegData(compressionQuality: 0.5) else {
               print("Error al convertir la foto en datos")
               return
           }
           
           // referencia al archivo en Firebase Storage
           let fotoRef = Storage.storage().reference().child("fotos_usuarios/\(uid).jpg")
           
           // subir la foto a Firebase Storage
           fotoRef.putData(fotoData, metadata: nil) { metadata, error in
               if let error = error {
                   print("Error al subir la foto a Firebase Storage: \(error.localizedDescription)")
               } else {
                   print("Foto subida exitosamente a Firebase Storage")
               }
           }
       }
   }
