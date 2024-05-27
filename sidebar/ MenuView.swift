//
//  MainView.swift
//  inventoryproios
//
//  Created by William Penado on 4/3/24.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Binding var showMenu: Bool
    @State private var showDetalleProducto = false

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Text(MenuLateral.etiqueta_de_menu)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 25)
            
            Button(action: {
                self.showMenu = false
            }) {
                menuItem(systemName: "house.fill", title: MenuLateral.inicio)
            }

            NavigationLink(destination: DetalleReporteInventarioScreen()) {
                menuItem(systemName: "info.circle", title: "Detalle Producto")
            }
            
            NavigationLink(destination: ReporteTransacScreen()) {
                menuItem(systemName: "arrow.up.arrow.down.circle.fill", title: "Transacciones Realizadas")
            }
            
            NavigationLink(destination: ReporteInventarioScreen()) {
                menuItem(systemName: "chart.bar.xaxis", title: "Reporte Stock")
            }

            if sessionManager.userPermissionType == "Administrador" {
                Group {
                    Text("Administrar Usuarios")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.top, 25)
                    
                    NavigationLink(destination: CreacionUsuarios()) {
                        menuItem(systemName: "person.badge.plus.fill", title: "Creación Usuarios")
                    }

                    NavigationLink(destination: VerUsuarios()) {
                        menuItem(systemName: "person.3.fill", title: "Ver Usuarios")
                    }
                }
            }

            Spacer()
            
            NavigationLink(destination: ForgotPasswordView()) {
                menuItem(systemName: "lock.fill", title: "Cambiar Contraseña")
            }
            
            Button(action: {
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
            }) {
                menuItem(systemName: "lock.fill", title: "Cerrar Sesión")
            }
            
            
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(ColorName.dark_green_color_132D39))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            sessionManager.fetchUserPermissionType()
        }
    }
    
    private func menuItem(systemName: String, title: String) -> some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(.white)
                .imageScale(.large)
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
        }
        .padding(.top, 25)
    }
}
