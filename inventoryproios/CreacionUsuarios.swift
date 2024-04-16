//
//  CreacionUsuarios.swift
//  inventoryproios
//
//  Created by Administrador on 15/4/24.
//

import SwiftUI

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
    @State private var fechaCreacion: Date = Date()
    @State private var fechaActualizacion: Date = Date()
    @State private var estatus: String = ""
    @State private var creadopor: String = ""

    @State private var showingImagePicker = false
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
                        Image(systemName: "person.2.fill")
                        TextField("Tipo Permiso", text: $tipoPermiso)
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
                
                Section(header: Text("Información del Sistema").font(.headline)) {
                    DatePicker("Fecha Creación", selection: $fechaCreacion, in: ...Date(), displayedComponents: .date)
                    HStack {
                        Image(systemName: "person.crop.rectangle.fill")
                        TextField("Creado por", text: $creadopor)
                    }
                    HStack {
                        Image(systemName: "circle.fill")
                        TextField("Estatus", text: $estatus)
                    }
                    // Agregar aquí la lógica para subir una imagen
                    
                }

                Section {
                    Button(action: {
                        // Añade la lógica para guardar los datos aquí
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
}
