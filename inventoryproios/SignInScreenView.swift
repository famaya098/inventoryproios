//
//  SignInScreenView.swift
//  inventoryproios
//
//  Created by Administrador on 24/3/24.
//


import SwiftUI
import FirebaseAuth

struct SignInScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var signInError: ErrorModel? = nil
    @State private var isLoggedIn: Bool = false
    
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
                        signIn()
                    }) {
                        Text("Ingresar")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                    }
                    .background(ColorName.light_green_color_132D39)
                    .cornerRadius(50.0)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    .padding(.vertical)
                    
                    Text("¿Olvidaste tu contraseña?")
                        .foregroundColor(ColorName.light_green_color_132D39)
                        .padding(.top, 10)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: WelcomeScreenView().environmentObject(SessionManager()))
                        window.makeKeyAndVisible()
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(ColorName.light_green_color_132D39)
                }
            )

            .alert(item: $signInError) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
                    HomePageScreenView()
                }
                .onDisappear {
                    UserDefaults.standard.set(email, forKey: "lastLoggedInEmail")
                }
            }
    
    private func signIn() {
        
        guard !email.isEmpty else {
            signInError = ErrorModel(message: "Ingrese su correo electrónico.")
            return
        }
        guard !password.isEmpty else {
            signInError = ErrorModel(message: "Ingrese su contraseña.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                signInError = ErrorModel(message: error.localizedDescription)
            } else {
                
                isLoggedIn = true
            }
        }
    }
}

struct ErrorModel: Identifiable {
    var id = UUID()
    var message: String
}
