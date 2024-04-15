//
//  WelcomeScreenView.swift
//  inventoryproios
//
//  Created by Administrador on 24/3/24.
//

import SwiftUI

struct WelcomeScreenView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image("inventario")
                    Spacer()
                    Text("InventoryPro")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("La herramienta esencial para una gestión de inventario eficaz")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    Spacer()
                    NavigationLink(
                        destination: SignInScreenView().navigationBarHidden(true),
                        label: {
                            Text("¡Empecemos!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(ColorName.light_green_color_132D39)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                                .padding(.vertical)
                        })
                        .navigationBarHidden(true)
                }
                .padding()
            }
        }
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}


