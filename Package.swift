// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DXBiometric",
    
    // MARK: - Default Localization
    defaultLocalization: "en",
    
    // MARK: - Platform Requirements
    platforms: [
        .iOS(.v12)
    ],
    
    // MARK: - Products
    products: [
        .library(
            name: "DXBiometric",
            targets: ["DXBiometric"]
        )
    ],
    
    // MARK: - Dependencies
    dependencies: [
        // No external dependencies
    ],
    
    // MARK: - Targets
    targets: [
        // Main SDK target
        .target(
            name: "DXBiometric",
            dependencies: [],
            path: "Sources/DXBiometric"
        ),
        
        // Test target
        .testTarget(
            name: "DXBiometricTests",
            dependencies: ["DXBiometric"],
            path: "Tests/DXBiometricTests"
        )
    ],
    
    // MARK: - Swift Language Version
    swiftLanguageVersions: [.v5]
)

