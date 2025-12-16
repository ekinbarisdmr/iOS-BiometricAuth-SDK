import Foundation

/// Main entry point for biometric authentication operations
///
/// This class provides a simple interface for checking biometric capabilities
/// and performing biometric authentication on iOS devices.
///
/// Usage:
/// ```swift
/// // Using singleton
/// DXBiometricAuth.shared.authenticate(reason: "Login") { result in
///     switch result {
///     case .success:
///         print("Authenticated!")
///     case .failure(let error):
///         print("Error: \(error.localizedDescription)")
///     }
/// }
///
/// // Using instance
/// let auth = DXBiometricAuth()
/// let type = auth.availableBiometricType()
/// ```
@available(iOS 12.0, macOS 10.13.2, *)
public final class DXBiometricAuth {
    
    // MARK: - Properties
    
    private let capabilityDetector: BiometricCapabilityDetector
    private let authenticator: BiometricAuthenticator
    
    // MARK: - Singleton
    
    /// Shared instance for convenient access
    public static let shared = DXBiometricAuth()
    
    // MARK: - Initialization
    
    /// Creates a new instance of DXBiometricAuth
    public init() {
        self.capabilityDetector = BiometricCapabilityDetector()
        self.authenticator = BiometricAuthenticator()
    }
    
    // MARK: - Public API
    
    /// Returns the type of biometric authentication available on the device
    ///
    /// - Returns: The biometric type (faceID, touchID, or none)
    public func availableBiometricType() -> BiometricType {
        return capabilityDetector.detectBiometricType()
    }
    
    /// Checks if biometric authentication is available and enrolled
    ///
    /// - Returns: `true` if biometric authentication can be used, `false` otherwise
    public func isBiometricAvailable() -> Bool {
        return capabilityDetector.isBiometricAvailable()
    }
    
    /// Performs biometric authentication with the given parameters
    ///
    /// - Parameters:
    ///   - reason: The reason for authentication, shown to the user
    ///   - fallbackTitle: Optional custom title for the fallback button
    ///   - completion: Completion handler called with the authentication result
    public func authenticate(
        reason: String,
        fallbackTitle: String? = nil,
        completion: @escaping (Result<Void, BiometricError>) -> Void
    ) {
        // Check if biometric authentication is available
        guard isBiometricAvailable() else {
            completion(.failure(.notAvailable))
            return
        }
        
        // Delegate to authenticator
        authenticator.authenticate(
            reason: reason,
            fallbackTitle: fallbackTitle,
            completion: completion
        )
    }
}

