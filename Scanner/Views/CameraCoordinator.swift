//
//  CameraCoordinator.swift
//  Scanner
//
//  Created by Matthew Deng on 2025-11-19.
//

import SwiftUI
import AVFoundation

class CameraCoordinator: NSObject, AVCapturePhotoCaptureDelegate {
    @Binding var capturedImage: UIImage?
    let session = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    
    init(capturedImage: Binding<UIImage?>) {
        _capturedImage = capturedImage
    }
    
    
    func configureSession() async throws {
        if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            await AVCaptureDevice.requestAccess(for: .video)
        }
        
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            throw NSError(domain: "CameraAccess", code: 1, userInfo: [NSLocalizedDescriptionKey: "Camera access denied"])
        }
        
        guard let camera = AVCaptureDevice.default(for: .video) else { return }
        let input = try AVCaptureDeviceInput(device: camera)
        
        session.beginConfiguration()
        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(output) { session.addOutput(output) }
        session.commitConfiguration()
        
        session.startRunning()
    }
    
    func capturePhoto() {
        print("capturePhoto() called")
        print("Session is running: \(session.isRunning)")
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
        print("capturePhoto requested")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        print("Photo capture callback called")
        if let error = error {
            print("Photo capture error: \(error)")
            return
        }
        guard let data = photo.fileDataRepresentation() else {
            print("Failed to get photo data")
            return
        }
        guard let image = UIImage(data: data) else {
            print("Failed to create UIImage from data")
            return
        }
        print("Successfully captured image: \(image.size)")
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}
