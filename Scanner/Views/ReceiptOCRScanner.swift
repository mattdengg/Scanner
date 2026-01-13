//
//  ReceiptOCRScanner.swift
//  Scanner
//
//  Created by Matthew Deng on 2025-11-13.
//

import SwiftUI
import Vision

struct CameraPreviewWrapper: UIViewRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var coordinator: CameraCoordinator?
    
    func makeUIView(context: Context) -> UIView {
        let view = ModernCameraView(session: context.coordinator.session)
        
        Task { @MainActor in
            coordinator = context.coordinator
            do { try await context.coordinator.configureSession() }
            catch { print("Camera setup failed:", error) }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> CameraCoordinator {
        CameraCoordinator(capturedImage: $capturedImage)
    }
}

struct ReceiptOCRScanner: View {
    @State private var capturedImage: UIImage?
    @State private var scannedReceipt: Receipt?
    @State private var isProcessing = false
    @State private var showCamera = true
    @State private var coordinator: CameraCoordinator?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showCamera {
                    CameraPreviewWrapper(capturedImage: $capturedImage, coordinator: $coordinator)
                        .ignoresSafeArea()
                } else if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                VStack {
                    Spacer()
                    if isProcessing {
                        ProgressView("Processing…")
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .padding()
                    }
                    Button("Scan Receipt") { captureAndProcess() }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 30)
                }
            }
            .navigationDestination(item: $scannedReceipt) { receipt in
                ReceiptDetailView(receipt: receipt)
            }
        }
    }
    
    func captureAndProcess() {
        guard !isProcessing else { return }
        isProcessing = true
        
        // First capture the photo
        capturedImage = nil
        coordinator?.capturePhoto()
        
        // Poll for the captured image
        Task {
            var attempts = 0
            while capturedImage == nil && attempts < 20 {
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                attempts += 1
            }
            
            guard let image = capturedImage else {
                print("No image captured after waiting")
                await MainActor.run { isProcessing = false }
                return
            }
            
            let text = await recognizeText(from: image)
            let receipt = parseReceiptFromText(text)
            
            await MainActor.run {
                scannedReceipt = receipt
                isProcessing = false
                showCamera = false
            }
        }
    }
    
    func recognizeText(from image: UIImage) async -> String {
        await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: "")
                    return
                }
                let text = observations
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")
                continuation.resume(returning: text)
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            guard let cgImage = image.cgImage else {
                continuation.resume(returning: "")
                return
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
}
