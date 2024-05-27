//
//  ForgotPasswordView.swift
//  parcia4_freddyamaya
//
//  Created by Administrador on 18/5/24.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        VStack {
            Spacer()
            Image("rest")
                .resizable()
                .frame(width: 225, height: 225)
            Text("Ingresa tu correo")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 15)
            Text("Se enviará un link para restablecer tu contraseña")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            VStack(spacing: 20) {
                TextField("Correo electrónico", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                Button(action: resetPassword) {
                    Text("Enviar")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                }
                .background(ColorName.light_green_color_132D39)
                .cornerRadius(50.0)
                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                .padding(.vertical)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Mensaje"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    // Cerramos sesión y redirigimos al usuario a SignInScreenView
                    sessionManager.signOut { result in
                        switch result {
                        case .success:
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = UIHostingController(rootView: SignInScreenView().environmentObject(SessionManager()))
                                window.makeKeyAndVisible()
                            }
                        case .failure(let error):
                            print("Error signing out: \(error)")
                        }
                    }
                }
            )
        
                }
            
    }

    func resetPassword() {
        if email.isEmpty {
            self.alertMessage = "Por favor, ingresa un correo electrónico."
            self.showAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                self.alertMessage = error?.localizedDescription ?? "Error desconocido"
                self.showAlert = true
                return
            }

            self.alertMessage = "Restablecimiento enviado. Por favor revisa tu bandeja de entrada."
            self.showAlert = true
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
