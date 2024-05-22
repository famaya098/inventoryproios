//
//  VerUsuarios.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import SwiftUI
import FirebaseDatabase
import SDWebImageSwiftUI



struct UserSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Buscar usuario", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top, 8)
            Spacer()
        }
    }
}

struct UserCardView: View {
    let usuario: UsuarioModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                WebImage(url: URL(string: usuario.fotoURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 3)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(usuario.nombres) \(usuario.apellidos)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(usuario.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(usuario.telefono)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 8)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Dirección: \(usuario.direccion)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("DUI: \(usuario.dui)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Fecha de Nacimiento: \(usuario.fechaNacimiento)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Fecha de Creación: \(usuario.fechaCreacion)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Tipo de Permiso: \(usuario.tipoPermiso)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Username: \(usuario.username)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Creado por: \(usuario.creadopor)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Estatus: \(usuario.estatus)")
                    .font(.caption)
                    .foregroundColor(usuario.estatus == "Activo" ? .green : .red)
                    .bold()
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(maxWidth: .infinity, minHeight: 200) // Ajusta el tamaño mínimo aquí
    }
}

struct VerUsuarios: View {
    @State private var usuarios: [UsuarioModel] = []
    @State private var searchText = ""
    @State private var selectedUsuario: UsuarioModel?
    
    var body: some View {
        NavigationView {
            VStack {
                UserSearchBar(text: $searchText)
                    .padding(.horizontal)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(usuarios.filter {
                            searchText.isEmpty ? true : $0.nombres.localizedCaseInsensitiveContains(searchText)
                        }) { usuario in
                            NavigationLink(destination: DetalleUsuarioView(usuario: usuario)) {
                                UserCardView(usuario: usuario)
                                    .padding(.horizontal)
                            }
//                            NavigationLink(destination: DetalleUsuarioView(usuario: usuario), tag: usuario, selection: $selectedUsuario) {
//                                UserCardView(usuario: usuario)
//                                    .padding(.horizontal)
//                            }
                        }
                    }
                }
                .navigationBarTitle("Listado de Usuarios", displayMode: .inline)
            }
            .onAppear {
                fetchUsuarios { usuarios in
                    self.usuarios = usuarios
                }
            }
        }
    }
    
    
}

struct VerUsuarios_Previews: PreviewProvider {
    static var previews: some View {
        VerUsuarios()
    }
}


