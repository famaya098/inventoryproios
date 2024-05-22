//
//  CreacionUsuarios.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseDatabase

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
    
    @State private var fechaCreacion = Date()
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage? = nil
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var alertMessage: AlertMessage?
    @State private var showAlert = false
    @State private var showSuccessNotification = false
    @State private var createdUser: String = ""
    
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
                
                Section(header: Text("Información del Sistema").font(.headline)) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Fecha: \(formattedDate(date: fechaCreacion))")
                    }
                    
                    Picker("Tipo Permiso", selection: $tipoPermiso) {
                        ForEach(["Administrador", "Usuario"], id: \.self) { role in
                            HStack {
                                if role == "Administrador" {
                                    Image(systemName: "person.fill")
                                } else {
                                    Image(systemName: "person")
                                }
                                Text(role)
                            }
                            .tag(role)
                        }
                    }

                    Picker("Estatus", selection: $estatus) {
                        ForEach(["Activo", "Inactivo"], id: \.self) { status in
                            HStack {
                                if status == "Activo" {
                                    Image(systemName: "checkmark.circle.fill")
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                Text(status)
                            }
                            .tag(status)
                        }
                    }
                }
                
                Section(header: Text("Creado por").font(.headline)) {
                    Text(createdUser)
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
            .onAppear {
                fechaCreacion = Date()
                loadCreatedUser()
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
    }
    
    func handleAlertDismissed() {
        self.alertMessage = nil
    }
    
//    func formattedDate(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
//        return formatter.string(from: date)
//    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func loadCreatedUser() {
        guard let user = Auth.auth().currentUser else {
            createdUser = "Desconocido"
            return
        }
        
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
        selectedImage = nil
        fechaCreacion = Date()
    }
    
    func signUp() {
        guard !email.isEmpty && !contrasena.isEmpty && !nombres.isEmpty && !apellidos.isEmpty && !dui.isEmpty && !username.isEmpty && !tipoPermiso.isEmpty && !telefono.isEmpty && !direccion.isEmpty else {
            self.alertMessage = AlertMessage(title: "Error", message: "Todos los campos son obligatorios. Asegúrate de completarlos antes de guardar.")
            self.showAlert = true
            print("Error: Campos vacíos")
            return
        }
        
        guard let _ = selectedImage else {
            self.alertMessage = AlertMessage(title: "Error", message: "Debes seleccionar una foto antes de guardar el usuario.")
            self.showAlert = true
            return
        }

        print("Todos los campos están completos. Continuando con el registro...")

        Auth.auth().createUser(withEmail: email, password: contrasena) { authResult, error in
            if let error = error {
                self.alertMessage = AlertMessage(title: "Error", message: "Error al registrar usuario: \(error.localizedDescription)")
                self.showAlert = true
                print("Error al registrar usuario:", error.localizedDescription)
            } else {
                self.creadopor = self.createdUser
                self.saveUserData()
            }
        }
    }
    
    func saveUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let image = selectedImage {
            uploadPhoto(uid: uid, image: image) { photoURL in
                if let photoURL = photoURL {
                    self.saveDataToDatabase(uid: uid, photoURL: photoURL)
                } else {
                    self.alertMessage = AlertMessage(title: "Error", message: "No se pudo obtener la URL de la foto.")
                    self.showAlert = true
                }
            }
        } else {
            self.saveDataToDatabase(uid: uid, photoURL: nil)
        }
    }
    
    func uploadPhoto(uid: String, image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("usuarios/\(uid).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error al subir la imagen a Firebase Storage: \(error.localizedDescription)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error al obtener la URL de descarga de la imagen: \(error.localizedDescription)")
                        completion(nil)
                    } else if let url = url {
                        completion(url.absoluteString)
                    }
                }
            }
        }
    }
    
    func saveDataToDatabase(uid: String, photoURL: String?) {
        let db = Database.database().reference()
        var userData: [String: Any] = [
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
        
        if let photoURL = photoURL {
            userData["fotoURL"] = photoURL
        }
        
        db.child("usuarios").child(uid).setValue(userData) { error, ref in
            if let error = error {
                print("Error al guardar datos del usuario en Realtime Database: \(error.localizedDescription)")
            } else {
                print("Datos del usuario guardados exitosamente en Realtime Database")
                self.alertMessage = AlertMessage(title: "Éxito", message: "\(username) ha sido creado correctamente.")
                self.showAlert = true
                self.clearFields()
            }
        }
    }
}
