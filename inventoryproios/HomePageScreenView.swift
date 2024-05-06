//
//  HomePageScreenView.swift
//  inventoryproios
//
//  Created by Administrador on 24/3/24.
//


import SwiftUI

struct HomePageScreenView: View {
    @State var showMenu = false
    let username: String
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        
        return NavigationView {
                   GeometryReader { geometry in
                       ZStack (alignment: .leading){
                           MainView(showMenu: self.$showMenu, username: self.username)
                               .frame(width: geometry.size.width,
                                      height: geometry.size.height)
                               .offset(x: self.showMenu ? geometry.size.width/2: 0)
                               .disabled(self.showMenu ? true : false)
                           if self.showMenu {
                               MenuView()
                                   .frame(width: geometry.size.width/2)
                                   .transition(.move(edge: .leading))
                           }
                       }
                       .gesture(drag)
                    }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))
        }
    }
}

struct MainView: View {
    @Binding var showMenu: Bool
    let username: String
    
    var body: some View {
        VStack {
            Text("¡Hola, \(username)!")
                .font(.title)
                .foregroundColor(.black)
                .padding(.top, 20)
            
            SearchBar()
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            AccessShortcuts()
                .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

struct SearchBar: View {
    @State private var searchText = ""

    var body: some View {
        TextField("¡Busca lo que necesites!", text: $searchText)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
    }
}

struct AccessShortcuts: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
            ForEach(shortcutsData) { shortcut in
                NavigationLink(destination: shortcut.destination) {
                    ShortcutView(shortcut: shortcut)
                }
            }
        }
    }
}

struct ShortcutView: View {
    let shortcut: ShortcutModel

    var body: some View {
        VStack {
            Image(shortcut.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .cornerRadius(20)
                .padding(.bottom, 5)

            Text(shortcut.title)
                .foregroundColor(.black)
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}


struct ShortcutModel: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let destination: AnyView
}

let shortcutsData: [ShortcutModel] = [
    ShortcutModel(imageName: "imagen12", title: "Agregar Productos", destination: AnyView(ProductosScreen())),
    ShortcutModel(imageName: "imagen6", title: "Realizar Transacción", destination: AnyView(AgregarTransac())),

    ShortcutModel(imageName: "imagen11", title: "Reporte Stock", destination: AnyView(ReporteInventarioScreen())),
    ShortcutModel(imageName: "imagen8", title: "Reporte Transacción", destination: AnyView(ReporteTransac()))
]

struct HomePageScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageScreenView(username: "Freddy") // Pasa un nombre de usuario de ejemplo para la vista previa
    }
}
