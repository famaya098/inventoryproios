//
//  DetalleUsuarioView.swift
//  inventoryproios
//
//  Created by Administrador on 20/5/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SDWebImageSwiftUI

struct DetalleUsuarioView: View {
    @State private var nombres: String
    @State private var apellidos: String
    @State private var telefono: String
    @State private var direccion: String
    @State private var dui: String
    @State private var fechaNacimiento: Date
    @State private var tipoPermiso: String
    @State private var username: String
    @State private var estatus: String
    @State private var fotoURL: String

    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var showAlert = false // Estado para controlar la alerta de eliminación

    @Environment(\.presentationMode) var presentationMode

    let usuario: UsuarioModel
    let databaseRef = Database.database().reference().child("usuarios")

    init(usuario: UsuarioModel) {
        self.usuario = usuario
        _nombres = State(initialValue: usuario.nombres)
        _apellidos = State(initialValue: usuario.apellidos)
        _telefono = State(initialValue: usuario.telefono)
        _direccion = State(initialValue: usuario.direccion)
        _dui = State(initialValue: usuario.dui)
        _fechaNacimiento = State(initialValue: DateFormatter.date(from: usuario.fechaNacimiento) ?? Date())
        _tipoPermiso = State(initialValue: usuario.tipoPermiso)
        _username = State(initialValue: usuario.username)
        _estatus = State(initialValue: usuario.estatus)
        _fotoURL = State(initialValue: usuario.fotoURL)
    }

    var body: some View {
        Form {
            Section(header: Text("Información Personal")) {
                HStack {
                    Text("Nombre:")
                        .bold()
                    Spacer()
                    TextField("Nombre", text: $nombres)
                }
                
                HStack {
                    Text("Teléfono:")
                        .bold()
                    Spacer()
                    TextField("Teléfono", text: $telefono)
                }
                
                HStack {
                    Text("Dirección:")
                        .bold()
                    Spacer()
                    TextField("Dirección", text: $direccion)
                }
                
                HStack {
                    Text("DUI:")
                        .bold()
                    Spacer()
                    TextField("DUI", text: $dui)
                }
                
                DatePicker("Fecha Nacimiento", selection: $fechaNacimiento, in: ...Date(), displayedComponents: .date)
                    .bold()
                
                Picker("Tipo Permiso:", selection: $tipoPermiso) {
                    ForEach(["Administrador", "Usuario"], id: \.self) { role in
                        Text(role).tag(role)
                    }
                }
                .bold()
                
                Picker("Estatus:", selection: $estatus) {
                    ForEach(["Activo", "Inactivo"], id: \.self) { status in
                        Text(status).tag(status)
                    }
                }.bold()
                
                HStack {
                    Text("Username:")
                        .bold()
                    Spacer()
                    TextField("Username", text: $username)
                }
            }

            Section(header: Text("Foto")) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(10)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    WebImage(url: URL(string: fotoURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(10)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }

                Button("Cambiar Foto") {
                    showingImagePicker = true
                }
                .padding()
            }
        }
        .navigationBarTitle("Detalles del Usuario", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            },
            trailing: HStack {
                Button(action: saveChanges) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    showAlert = true // Mostrar alerta de confirmación de eliminación
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirmar eliminación"),
                message: Text("¿Estás seguro de que deseas eliminar este usuario?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    eliminarUsuario()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }

    func saveChanges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        if let selectedImage = selectedImage {
            uploadPhoto(userId: userId, image: selectedImage) { url in
                if let url = url {
                    self.fotoURL = url
                    self.updateUserData()
                }
            }
        } else {
            updateUserData()
        }
    }

    func updateUserData() {
        let userData: [String: Any] = [
            "nombres": nombres,
            "apellidos": apellidos,
            "telefono": telefono,
            "direccion": direccion,
            "dui": dui,
            "fechaNacimiento": formattedDate(date: fechaNacimiento),
            "tipoPermiso": tipoPermiso,
            "username": username,
            "estatus": estatus,
            "fotoURL": fotoURL
        ]

        databaseRef.child(usuario.id).updateChildValues(userData) { error, ref in
            if let error = error {
                print("Error updating user data: \(error.localizedDescription)")
            } else {
                print("User data updated successfully.")
            }
        }
    }

    func eliminarUsuario() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("usuarios").child(usuario.id)
        
        ref.removeValue { error, _ in
            if let error = error {
                print("Error al eliminar el usuario: \(error.localizedDescription)")
            } else {
                print("Usuario eliminado exitosamente")
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    func uploadPhoto(userId: String, image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("usuarios/\(userId).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        completion(nil)
                    } else if let url = url {
                        completion(url.absoluteString)
                    }
                }
            }
        }
    }

    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

extension DateFormatter {
    static func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
}
