//
//  printProductList.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import UIKit

func printProductList(_ productList: [ProductoModel]) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy 'at' HH:mm:ss"
    let currentDate = dateFormatter.string(from: Date())
    
    var reportString = """
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; }
            h1 { text-align: center; }
            .info { margin-bottom: 20px; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
        </style>
    </head>
    <body>
        <h1>INFORME DE PRODUCTOS</h1>
        <div class="info">
            <p><strong>InventoryPro</strong> </p>
            <p><strong>Fecha y Hora:</strong> \(currentDate)</p>
        </div>
        <table>
            <tr>
                <th>Nombre</th>
                <th>Código</th>
                <th>Estatus</th>
                <th>Fecha Creación</th>
                <th>Precio Compra</th>
                <th>Precio Venta</th>
                <th>Unidad</th>
                <th>Creado por</th>
                <th>Cantidad en Stock</th>
            </tr>
    """
    
    for product in productList {
        reportString += """
        <tr>
            <td>\(product.nombre)</td>
            <td>\(product.codigo)</td>
            <td>\(product.estatus)</td>
            <td>\(product.fechaCreacion)</td>
            <td>\(product.precioCompra)</td>
            <td>\(product.precioVenta)</td>
            <td>\(product.unidad)</td>
            <td>\(product.createdUser)</td>
            <td>\(product.cantidad)</td>
        </tr>
        """
    }
    
    reportString += """
        </table>
    </body>
    </html>
    """
    
    let printInfo = UIPrintInfo(dictionary: nil)
    printInfo.outputType = .general
    printInfo.jobName = "Product List"

    let printController = UIPrintInteractionController.shared
    printController.printInfo = printInfo
    printController.showsNumberOfCopies = false

    let printFormatter = UIMarkupTextPrintFormatter(markupText: reportString)
    printController.printFormatter = printFormatter

    DispatchQueue.main.async {
        printController.present(animated: true, completionHandler: nil)
    }
}
