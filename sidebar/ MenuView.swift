//
//  MainView.swift
//  inventoryproios
//
//  Created by William Penado on 4/3/24.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Text(MenuLateral.etiqueta_de_menu)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 25)
            
            NavigationLink(destination: EmptyView()) {
                menuItem(systemName: "house.fill", title: MenuLateral.inicio)
            }
            
            NavigationLink(destination: EmptyView()) {
                                menuItem(systemName: "info.circle", title: "Detalle del Producto")
                            }
            
            NavigationLink(destination: EmptyView()) {
                menuItem(systemName: "arrow.up.arrow.down.circle.fill", title: "Transacciones Realizadas")
            }
            
            NavigationLink(destination: EmptyView()) {
                menuItem(systemName: "chart.bar.xaxis", title: "Reporte Stock")
            }
            
            NavigationLink(destination: EmptyView()) {
                menuItem(systemName: "chart.pie", title: "Reporte Transacciones")
            }
            
            NavigationLink(destination: CambiarContrasena()) {
                menuItem(systemName: "key.fill", title: "Cambiar Contraseña")
            }

            
            NavigationLink(destination: CreacionUsuarios()) {
                menuItem(systemName: "person.2.fill", title: MenuLateral.administrarAcceso)
            }

            Spacer()
            
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

struct MenuView_Preview: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
