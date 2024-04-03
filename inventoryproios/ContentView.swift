//
//  ContentView.swift
//  inventoryproios
//
//  Created by Administrador on 24/3/24.
//

import SwiftUI

struct ContentView: View {
   
    var body: some View {
        WelcomeScreenView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PrimaryButton: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(ColorName.light_green_color_132D39)
            .cornerRadius(50)
    }
}
