//
//  ReceiptShareActions.swift
//  Scanner
//
//  Created by Matthew Deng on 2025-11-19.
//

import Foundation
import UIKit
import SwiftUI
import PDFKit

struct ReceiptShareActions {
    
    static func formattedText(from receipt: Receipt) -> String {
        var lines: [String] = []
        lines.append("Store: \(receipt.store)\n")
        lines.append("Items:")
        
        for item in receipt.items {
            lines.append("• \(item.name) - $\(String(format: "%.2f", item.price))")
        }
        
        lines.append("")
        if let subtotal = receipt.subtotal { lines.append("Subtotal: $\(String(format: "%.2f", subtotal))") }
        if let tax = receipt.tax { lines.append("Tax: $\(String(format: "%.2f", tax))") }
        if let total = receipt.total { lines.append("Total: $\(String(format: "%.2f", total))") }
        
        return lines.joined(separator: "\n")
    }
    
    static func createPDF(from receipt: Receipt) -> URL? {
        let text = formattedText(from: receipt)
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Receipt Scanner"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("receipt.pdf")
        
        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()
                text.draw(
                    in: CGRect(x: 20, y: 20, width: pageRect.width - 40, height: pageRect.height - 40),
                    withAttributes: [.font: UIFont.systemFont(ofSize: 14)]
                )
            }
            return url
        } catch {
            print("PDF generation error:", error)
            return nil
        }
    }
    
    static func exportToNotes(receipt: Receipt) {
        let text = formattedText(from: receipt)
        
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    static func copyToClipboard(receipt: Receipt) {
        let text = formattedText(from: receipt)
        UIPasteboard.general.string = text
    }
    
}
