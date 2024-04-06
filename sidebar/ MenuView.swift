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
                Image("William_Penado_profile_picture")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 25)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                    .shadow(color: .gray, radius: 20, x: 0, y: 2)
                    .offset(x: -30, y: 15)
                VStack {
                    Text(MenuLateral.nombre_de_perfil)
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .offset(x: -40, y: 15)
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.green)
                            .offset(x: -50, y: 20)
                        Text("En línea")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .offset(x: -50, y: 20)
                    }
                }
            }.padding(.top, 25)
            HStack {
                Text(MenuLateral.etiqueta_de_menu)
                    .font(.headline)
                    .foregroundColor(.white)
            }.padding(.top, 25)
            HStack {
                Image(systemName: "house.circle.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.inicio)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 10)
            HStack {
                Image(systemName: "suitcase.cart.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.compras)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 25)
            HStack {
                Image(systemName: "shippingbox.circle.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.productos)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 25)
            HStack {
                Image(systemName: "tag.slash.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.fabricante)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 25)
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.contactos)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 25)
            HStack {
                Image(systemName: "dollarsign")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.facturacion)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 25)
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.reportes)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 25)
            HStack {
                Image(systemName: "wrench")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.configuracion)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 25)
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text(MenuLateral.administrarAcceso)
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding(.top, 25)
            Spacer()
        }.padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .background(Color(ColorName.dark_green_color_132D39))
            .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Preview: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
