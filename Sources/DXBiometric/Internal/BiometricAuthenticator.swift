import Foundation
import LocalAuthentication

/// Handles biometric authentication operations
///
/// This class wraps LocalAuthentication framework and provides
/// a clean interface for performing biometric authentication.
@available(iOS 11.0, macOS 10.13.2, *)
internal final class BiometricAuthenticator {
    
    // MARK: - Properties
    
    // Context factory to create new contexts for each authentication
    private let contextFactory: () -> LAContextProtocol
    
    // MARK: - Initialization
    
    init(contextFactory: @escaping () -> LAContextProtocol = { LAContext() }) {
        self.contextFactory = contextFactory
    }
    
    // MARK: - Internal Methods
    
    /// Performs biometric authentication
    ///
    /// - Parameters:
    ///   - reason: The reason shown to the user for authentication
    ///   - fallbackTitle: Optional custom title for the fallback button
    ///   - completion: Completion handler with Result<Void, BiometricError>
    func authenticate(
        reason: String,
        fallbackTitle: String?,
        completion: @escaping (Result<Void, BiometricError>) -> Void
    ) {
        // Create a new context for this authentication attempt
        var context = contextFactory()
        
        // Set fallback title if provided
        if let fallbackTitle = fallbackTitle {
            context.localizedFallbackTitle = fallbackTitle
        }
        
        // Evaluate biometric policy
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        ) { [weak self] success, error in
            // Ensure completion is called on main thread
            DispatchQueue.main.async {
                if success {
                    // Authentication successful
                    completion(.success(()))
                } else {
                    // Authentication failed - map error
                    let biometricError = self?.mapError(error) ?? .unknown
                    completion(.failure(biometricError))
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Maps LAError to BiometricError
    ///
    /// - Parameter error: The error from LocalAuthentication
    /// - Returns: Corresponding BiometricError
    private func mapError(_ error: Error?) -> BiometricError {
        guard let error = error else {
            return .unknown
        }
        
        // Cast to NSError to access code
        let nsError = error as NSError
        
        // Map LAError codes to BiometricError
        guard nsError.domain == LAError.errorDomain else {
            return .systemError(nsError.localizedDescription)
        }
        
        let laErrorCode = LAError.Code(rawValue: nsError.code)
        
        switch laErrorCode {
        case .userCancel:
            return .cancelled
            
        case .userFallback:
            return .fallback
            
        case .biometryNotAvailable:
            return .notAvailable
            
        case .biometryNotEnrolled:
            return .notEnrolled
            
        case .biometryLockout:
            return .lockout
            
        case .authenticationFailed:
            // User failed to provide valid credentials (e.g., wrong finger)
            return .systemError("Authentication failed")
            
        case .appCancel, .systemCancel:
            // App or system cancelled the authentication
            return .cancelled
            
        case .invalidContext:
            // Context is invalid
            return .systemError("Invalid context")
            
        case .passcodeNotSet:
            // Passcode is not set on device
            return .notEnrolled
            
        default:
            return .unknown
        }
    }
}

