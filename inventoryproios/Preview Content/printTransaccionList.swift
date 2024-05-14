//
//  printTransaccionList.swift
//  inventoryproios
//
//  Created by Administrador on 13/5/24.
//

import UIKit

func printTransaccionList(_ transaccionList: [TransaccionModel]) {
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
        <h1>INFORME DE TRANSACCIONES</h1>
        <div class="info">
            <p><strong>InventoryPro</strong></p>
            <p><strong>Fecha y Hora:</strong> \(currentDate)</p>
        </div>
        <table>
            <tr>
                <th>Producto</th>
                <th>Código Transacción</th>
                <th>Tipo</th>
                <th>Cantidad</th>
                <th>Stock Inicial</th>
                <th>Stock Final</th>
                <th>Creado por</th>
                <th>Fecha Creación</th>
            </tr>
    """
    
    for transaccion in transaccionList {
        reportString += """
        <tr>
            <td>\(transaccion.nombreProducto)</td>
            <td>\(transaccion.codigoTransaccion)</td>
            <td>\(transaccion.tipoTransaccion)</td>
            <td>\(transaccion.cantidadIngresada)</td>
            <td>\(transaccion.stockInicial)</td>
            <td>\(transaccion.stockFinal)</td>
            <td>\(transaccion.creadoPor)</td>
            <td>\(transaccion.fechaCreacion)</td>
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
    printInfo.jobName = "Transaction List"

    let printController = UIPrintInteractionController.shared
    printController.printInfo = printInfo
    printController.showsNumberOfCopies = false

    let printFormatter = UIMarkupTextPrintFormatter(markupText: reportString)
    printController.printFormatter = printFormatter

    DispatchQueue.main.async {
        printController.present(animated: true, completionHandler: nil)
    }
}
