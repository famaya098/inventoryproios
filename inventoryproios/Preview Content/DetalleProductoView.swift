//
//  DetalleProductoView.swift
//  inventoryproios
//
//  Created by Administrador on 20/5/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseStorage
import SDWebImageSwiftUI

struct DetalleProductoView: View {
    @State var producto: ProductoModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showAlert = false // Estado para controlar la alerta

    var body: some View {
        Form {
            Section(header: Text("Detalles del Producto").font(.headline)) {
                HStack {
                    Text("Código:")
                        .bold()
                    Text(producto.codigo)
                }

                HStack {
                    Text("Nombre:")
                        .bold()
                    Spacer()
                    TextField("Nombre", text: $producto.nombre)
                }

                VStack(alignment: .leading) {
                    Text("Descripción:")
                        .bold()
                    TextEditor(text: $producto.descripcion)
                        .frame(height: 100)
                        .cornerRadius(5)
                        .padding(.top, 5)
                }

                HStack {
                    Text("Precio de Compra: $")
                        .bold()
                    Spacer()
                    TextField("Precio de Compra", text: $producto.precioCompra)
                        .keyboardType(.decimalPad)
                }

                HStack {
                    Text("Precio de Venta: $")
                        .bold()
                    Spacer()
                    TextField("Precio de Venta", text: $producto.precioVenta)
                        .keyboardType(.decimalPad)
                }

                HStack {
                    Text("Stock Actual:")
                        .bold()
                    Text(producto.cantidad)
                }

                HStack {
                    Text("Tipo Unidad:")
                        .bold()
                    Spacer()
                    TextField("Unidad", text: $producto.unidad)
                }

                HStack {
                    Text("Creado por:")
                        .bold()
                    Text(producto.createdUser)
                }

                
            }
            Section(header: Text("Foto")) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(10)
                } else {
                    WebImage(url: URL(string: producto.photoURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(10)
                }

                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Cambiar Foto")
                }
                .padding()
            }
        }
        .navigationBarTitle("Detalles del Producto", displayMode: .inline)
        .disabled(isLoading)
        .navigationBarBackButtonHidden(true) // Oculta la flecha de retroceso predeterminada
        .navigationBarItems(
            leading: Button(action: {
                // Acción para volver atrás
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left") // Icono de flecha izquierda
                    .foregroundColor(.blue)
            },
            trailing: HStack {
                Button(action: actualizarProducto) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                }

                Button(action: {
                    showAlert = true // Mostrar alerta al intentar eliminar
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirmar eliminación"),
                message: Text("¿Estás seguro de que deseas eliminar este producto?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    eliminarProducto()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(image: $selectedImage)
        })
    }

    private func actualizarProducto() {
        isLoading = true

        if let selectedImage = selectedImage {
            uploadImage(selectedImage) { url in
                guard let url = url else {
                    isLoading = false
                    return
                }
                self.producto.photoURL = url.absoluteString
                self.updateProductData()
            }
        } else {
            updateProductData()
        }
    }

    private func updateProductData() {
        let ref = Database.database().reference().child("productos").child(producto.id)
        let updatedValues: [String: Any] = [
            "nombre": producto.nombre,
            "descripcion": producto.descripcion,
            "precioCompra": producto.precioCompra,
            "precioVenta": producto.precioVenta,
            "cantidad": producto.cantidad,
            "unidad": producto.unidad,
            "photoURL": producto.photoURL
        ]

        ref.updateChildValues(updatedValues) { error, _ in
            isLoading = false
            if let error = error {
                print("Error al actualizar el producto: \(error.localizedDescription)")
            } else {
                print("Producto actualizado exitosamente")
            }
        }
    }

    private func eliminarProducto() {
        isLoading = true
        let ref = Database.database().reference().child("productos").child(producto.id)

        ref.removeValue { error, _ in
            isLoading = false
            if let error = error {
                print("Error al eliminar el producto: \(error.localizedDescription)")
            } else {
                print("Producto eliminado exitosamente")
            }
            self.presentationMode.wrappedValue.dismiss() // Volver atrás después de eliminar
        }
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("productos").child("\(UUID().uuidString).jpg")

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error al subir la imagen: \(error.localizedDescription)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, _ in
                completion(url)
            }
        }
    }
}

// ImagePicker
struct ImagePickerr: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerr

        init(parent: ImagePickerr) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
