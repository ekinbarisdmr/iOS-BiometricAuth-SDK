Pod::Spec.new do |spec|
  # MARK: - Basic Information
  spec.name         = 'DXBiometric'
  spec.version      = '1.0.0'
  spec.summary      = 'A clean, testable iOS Biometric Authentication SDK'
  
  spec.description  = <<-DESC
    DXBiometric is a production-ready iOS SDK for biometric authentication.
    It provides a simple, clean API for Face ID and Touch ID authentication
    with built-in error handling, localization support, and testable architecture.
    
    Features:
    - Face ID and Touch ID support
    - iOS 12.0+ compatibility
    - Built-in English and Turkish localization
    - Protocol-based testable architecture
    - Thread-safe operations
    - Clean Result-based API
  DESC

  # MARK: - URLs and Metadata
  spec.homepage     = 'https://www.definex.com'
  spec.license      = { :type => 'Proprietary', :text => 'Copyright © 2025 DefineX. All rights reserved.' }
  spec.author       = { 'DefineX' => 'info@definex.com' }
  
  # MARK: - Source
  # For local development, use: pod 'DXBiometric', :path => '../DXBiometric'
  spec.source       = { :git => 'https://github.com/DefineX/DXBiometric.git', :tag => "#{spec.version}" }
  
  # MARK: - Platform Requirements
  spec.ios.deployment_target = '12.0'
  spec.swift_version = '5.7'
  
  # MARK: - Source Files
  spec.source_files = 'Sources/DXBiometric/**/*.{swift}'
  
  # MARK: - Resources
  spec.resource_bundles = {
    'DXBiometric' => ['Sources/DXBiometric/Resources/**/*']
  }
  
  # MARK: - Frameworks
  spec.frameworks = 'Foundation', 'LocalAuthentication'
  
  # MARK: - Dependencies
  # No external dependencies
  
  # MARK: - Build Settings
  spec.requires_arc = true
  
  # MARK: - Module
  spec.module_name = 'DXBiometric'
end

