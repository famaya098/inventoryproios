//
//  MainView.swift
//  inventoryproios
//
//  Created by William Penado on 4/3/24.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "house.circle.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Inicio")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            HStack {
                Image(systemName: "suitcase.cart.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Compras")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            HStack {
                Image(systemName: "shippingbox.circle.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Productos")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            HStack {
                Image(systemName: "tag.slash.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Fabricante")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Contactos")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            HStack {
                Image(systemName: "dollarsign")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Facturación")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Reportes")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            HStack {
                Image(systemName: "wrench")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Configuración")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Administrar accesos")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 35)
            Spacer()
        }.padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .background(Color(ColorName.dark_green_color_132D39))
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct MenuView_Preview: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
