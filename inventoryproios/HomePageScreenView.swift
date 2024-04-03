//
//  HomePageScreenView.swift
//  inventoryproios
//
//  Created by Administrador on 24/3/24.
//

import SwiftUI

struct HomePageScreenView: View {
    var body: some View {
        VStack {
            HeaderView()
            Text("Welcome to InventoryPro!")
                .font(.title)
                .fontWeight(.bold)
        }   
    }
}


