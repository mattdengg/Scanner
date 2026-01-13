//
//  ReceiptItem.swift
//  Scanner
//
//  Created by Matthew Deng on 2025-11-18.
//

import Foundation

struct ReceiptItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let name: String
    let price: Double
}

struct Receipt: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var items: [ReceiptItem]
    var subtotal: Double?
    var tax: Double?
    var total: Double?
    var store: String = ""
}

private let priceRegex = try! NSRegularExpression(pattern: #"(\d{1,3}(?:,\d{3})*\.\d{2}|\d+\.\d{2})"#)

func extractedPrice(from line: String) -> Double? {
    let range = NSRange(line.startIndex..<line.endIndex, in: line)
    guard let match = priceRegex.firstMatch(in: line, options: [], range: range),
          let priceRange = Range(match.range, in: line) else { return nil }
    
    let raw = String(line[priceRange]).replacingOccurrences(of: ",", with: "")
    return Double(raw)
}

func parseReceiptFromText(_ text: String) -> Receipt {
    let lines = text.components(separatedBy: .newlines)
    
    var items: [ReceiptItem] = []
    var subtotal: Double?
    var tax: Double?
    var total: Double?
    var store: String = ""
    
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { continue }
        let lower = trimmed.lowercased()
        
        if store.isEmpty, extractedPrice(from: trimmed) == nil, !lower.contains("total"), trimmed.count < 40 {
            store = trimmed
        }
        
        if lower.contains("subtotal"), let price = extractedPrice(from: trimmed) {
            subtotal = price
            continue
        }
        if lower.contains("tax"), let price = extractedPrice(from: trimmed) {
            tax = price
            continue
        }
        if lower.contains("total"), let price = extractedPrice(from: trimmed) {
            total = price
            continue
        }
        
        if let price = extractedPrice(from: trimmed) {
            var name = trimmed.replacingOccurrences(of: String(format: "%.2f", price), with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            if name.isEmpty { name = "Item" }
            items.append(ReceiptItem(name: name, price: price))
        }
    }
    
    return Receipt(items: items, subtotal: subtotal, tax: tax, total: total, store: store)
}

