//
//  ReceiptDetailView.swift
//  Scanner
//
//  Created by Matthew Deng on 2025-11-18.
//

import SwiftUI

struct ReceiptDetailView: View {
    let receipt: Receipt
    
    @State private var showCopiedText = false
    @State private var showShareSheet = false
    @State private var pdfURL: URL?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(receipt.store)
                .font(.title)
                .padding(.bottom)
            
            List {
                Section("Items") {
                    ForEach(receipt.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(String(format: "%.2f", item.price))")
                        }
                    }
                }
                
                Section("Summary") {
                    if let subtotal = receipt.subtotal {
                        HStack {
                            Text("Subtotal")
                            Spacer()
                            Text("$\(String(format: "%.2f", subtotal))")
                        }
                    }
                    if let tax = receipt.tax {
                        HStack {
                            Text("Tax")
                            Spacer()
                            Text("$\(String(format: "%.2f", tax))")
                        }
                    }
                    if let total = receipt.total {
                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                            Spacer()
                            Text("$\(String(format: "%.2f", total))")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Receipt")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        ReceiptShareActions.copyToClipboard(receipt: receipt)
                        withAnimation {
                            showCopiedText = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showCopiedText = false
                            }
                        }
                    } label: {
                        Label("Copy Text", systemImage: "doc.on.doc")
                    }
                    
                    Button {
                        if let url = ReceiptShareActions.createPDF(from: receipt) {
                            pdfURL = url
                            showShareSheet = true
                        }
                    } label: {
                        Label("Share…", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        ReceiptShareActions.exportToNotes(receipt: receipt)
                    } label: {
                        Label("Export to Notes", systemImage: "note.text")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        
        .sheet(isPresented: $showShareSheet) {
            if let url = pdfURL {
                ShareSheet(activityItems: [url])
            }
        }
        
        .overlay(alignment: .center) {
            if showCopiedText {
                Text("Copied!")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
