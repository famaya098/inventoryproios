//
//  CambiarContrasena.swift
//  inventoryproios
//
//  Created by Administrador on 19/4/24.
//

import SwiftUI

struct CambiarContrasena: View {
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var repeatPassword: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cambiar Contraseña").font(.headline)) {
                    HStack {
                        Image(systemName: "lock.fill")
                        SecureField("Contraseña Antigua", text: $oldPassword)
                    }
                    HStack {
                        Image(systemName: "lock.fill")
                        SecureField("Contraseña Nueva", text: $newPassword)
                    }
                    HStack {
                        Image(systemName: "lock.fill")
                        SecureField("Repetir Contraseña Nueva", text: $repeatPassword)
                    }
                }

                Section {
                    Button(action: {
                        // Lógica para cambiar la contraseña
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
            .navigationBarTitle("Cambiar Contraseña", displayMode: .inline)
            .padding()
        }
    }
}
