Pod::Spec.new do |spec|
  # MARK: - Basic Information
  spec.name         = 'DXBiometric'
  spec.version      = '1.0.1'
  spec.summary      = 'A clean, testable iOS Biometric Authentication SDK'
  
  spec.description  = <<-DESC
    DXBiometric is a production-ready iOS SDK for biometric authentication.
    It provides a simple, clean API for Face ID and Touch ID authentication
    with built-in error handling and testable architecture.
    
    Features:
    - Face ID and Touch ID support
    - iOS 12.0+ compatibility
    - Swift 6 concurrency compatible
    - Protocol-based testable architecture
    - Thread-safe operations
    - Clean Result-based API
    - Semantic error types for flexible UI handling
  DESC

  # MARK: - URLs and Metadata
  spec.homepage     = 'https://github.com/ekinbarisdmr/iOS-BiometricAuth-SDK'
  spec.license      = { :type => 'Proprietary', :file => 'LICENSE' }
  spec.author       = { 'Ekin Barış Demir' => 'ekin.demir@teamdefinex.com' }
  
  # MARK: - Source
  # For local development, use: pod 'DXBiometric', :path => '../DXBiometric'
  spec.source       = { :git => 'https://github.com/ekinbarisdmr/iOS-BiometricAuth-SDK.git', :tag => "#{spec.version}" }
  
  # MARK: - Platform Requirements
  spec.ios.deployment_target = '12.0'
  spec.swift_version = '5.7'

  # ✅ SDK-side fix: force static framework even if apps use `use_frameworks!`
  # This prevents dynamic framework embedding issues with rsync/_CodeSignature
  spec.static_framework = true
  
  # ✅ Disable code signing for pod target to prevent rsync permission errors
  # These settings apply ONLY to the pod target, not the host app
  spec.pod_target_xcconfig = {
    'CODE_SIGNING_ALLOWED' => 'NO',
    'CODE_SIGNING_REQUIRED' => 'NO',
    'CODE_SIGNING_IDENTITY' => '',
    'EXPANDED_CODE_SIGN_IDENTITY' => '',
    'DEVELOPMENT_TEAM' => ''
  }
  
  # MARK: - Source Files
  spec.source_files = 'Sources/DXBiometric/**/*.{swift}'
  
  # MARK: - Frameworks
  spec.frameworks = 'Foundation', 'LocalAuthentication'
  
  # MARK: - Dependencies
  # No external dependencies
  
  # MARK: - Build Settings
  spec.requires_arc = true
  
  # MARK: - Module
  spec.module_name = 'DXBiometric'
end

