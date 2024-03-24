//
//  SignInScreenView.swift
//  inventoryproios
//
//  Created by Administrador on 24/3/24.
//

import SwiftUI

struct SignInScreenView: View {
    @Environment(\.presentationMode) var presentationMode // Para controlar la navegación
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("finance_app")
                        .resizable()
                        .frame(width: 300, height: 225)
                    
                    Text("Ingresa con tu cuenta")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 15)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 6).stroke(Color.blue, lineWidth: 2))
                        .padding(.top, 10)
                    
                    HStack(spacing: 15) {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Contraseña", text: $password)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill" )
                                .foregroundColor(.blue)
                                .opacity(0.8)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 6).stroke(Color.blue, lineWidth: 2))
                    .padding(.top, 10)
                    
                    Button(action: {
                        
                    }) {
                        Text("Ingresar")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color("PrimaryColor"))
                    .cornerRadius(50.0)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    .padding(.vertical)
                    
                    Text("¿Olvidaste tu contraseña?")
                        .foregroundColor(Color("PrimaryColor"))
                        .padding(.top, 10)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color("PrimaryColor"))
                }
            )
        }
    }
}


