# Scanner

## Overview

Scanner is a modern receipt scanning and parsing application that combines iOS native development with AI-powered document processing. The app allows users to capture receipts with their device camera, extract text using optical character recognition (OCR), and parse the information into structured data including item names, prices, tax, and totals.

## Features

### iOS App
- **Real-time Camera Preview**: Native AVFoundation-based camera interface with live preview
- **Receipt Capture**: One-tap photo capture optimized for document scanning
- **OCR Processing**: On-device text recognition using Apple's Vision framework
- **Smart Parsing**: Automatic extraction of:
  - Store name
  - Individual items with names and prices
  - Subtotal, tax, and total amounts
- **Receipt Management**: View and manage scanned receipts with detailed breakdowns
- **Share Functionality**: Export receipts as text or structured data

### Backend API
- **FastAPI Framework**: High-performance Python backend with async support
- **AI Parser Service**: Extensible architecture for AI-powered document parsing
- **RESTful API Endpoints**:
  - Health check
  - Document parsing
  - Text extraction
  - Document classification
- **CORS Support**: Configured for cross-origin requests from mobile clients

## Architecture

### iOS App (Swift/SwiftUI)
```
Scanner/
├── ScannerApp.swift           # Main app entry point
├── Models/
│   └── ReceiptItem.swift      # Data models and parsing logic
├── Views/
│   ├── ReceiptOCRScanner.swift    # Main scanner view
│   ├── ModernCameraView.swift     # Camera preview
│   ├── CameraCoordinator.swift    # Camera session management
│   ├── ReceiptDetailView.swift    # Receipt display
│   └── ReceiptShareActions.swift  # Export functionality
└── Assets.xcassets            # App assets and icons
```

### Backend (Python/FastAPI)
```
Backend/
├── app/
│   ├── main.py                # FastAPI application
│   ├── api/routes/            # API endpoints
│   ├── core/config.py         # Configuration management
│   ├── models/schemas.py      # Pydantic data models
│   └── services/ai_parser.py  # AI parsing service
├── tests/                     # Test suite
└── requirements.txt           # Python dependencies
```

## Technology Stack

### Frontend
- **SwiftUI**: Modern declarative UI framework
- **AVFoundation**: Camera capture and media processing
- **Vision Framework**: On-device OCR and text recognition
- **iOS 15+**: Target deployment

### Backend
- **FastAPI**: Modern Python web framework
- **Pydantic**: Data validation and settings management
- **Uvicorn**: ASGI server for production deployment
- **Python 3.8+**: Runtime environment

