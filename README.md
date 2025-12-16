# DXBiometric

A clean, testable, and production-ready iOS Biometric Authentication SDK.

## Features

- 🔐 Face ID and Touch ID support
- 📱 iOS 12.0+ compatibility
- 🌍 Built-in localization (English, Turkish)
- ✅ Protocol-based testable architecture
- 🎯 Clean and simple public API
- 📦 Multiple distribution methods (SPM, CocoaPods, Carthage)

## Requirements

- iOS 12.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/DefineX/DXBiometric.git", from: "1.0.0")
]
```

### CocoaPods

```ruby
pod 'DXBiometric', '~> 1.0'
```

### Carthage

```
github "DefineX/DXBiometric" ~> 1.0
```

## Usage

```swift
import DXBiometric

// Check available biometric type
let type = DXBiometricAuth.shared.availableBiometricType()

switch type {
case .faceID:
    print("Face ID available")
case .touchID:
    print("Touch ID available")
case .none:
    print("No biometric support")
}

// Perform authentication
DXBiometricAuth.shared.authenticate(
    reason: "Authenticate to access your account",
    fallbackTitle: "Use Password"
) { result in
    switch result {
    case .success:
        print("Authentication successful")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

## Architecture

```
DXBiometric
├── Public API (Facade)
│   ├── DXBiometricAuth
│   ├── BiometricType
│   └── BiometricError
├── Internal Logic
│   ├── BiometricAuthenticator
│   ├── BiometricCapabilityDetector
│   └── LAContextProtocol
└── Resources
    └── Localizations (en, tr)
```

## License

Copyright © 2025 DefineX. All rights reserved.

