//
//  HeaderView.swift
//  inventoryproios
//
//  Created by William Penado on 3/28/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            Color(ColorName.light_green_color_132D39)
                .ignoresSafeArea(.all)
            HStack {
                Text("Control de inventario")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    HeaderView()
}
