import Foundation
import LocalAuthentication

/// Detects the biometric capabilities of the device
///
/// This class is responsible for determining what type of biometric authentication
/// is available on the current device (Face ID, Touch ID, or none).
@available(iOS 11.0, macOS 10.13.2, *)
internal final class BiometricCapabilityDetector {
    
    // MARK: - Properties
    
    private let context: LAContextProtocol
    
    // MARK: - Initialization
    
    init(context: LAContextProtocol = LAContext()) {
        self.context = context
    }
    
    // MARK: - Internal Methods
    
    /// Detects the available biometric type on the device
    ///
    /// - Returns: The type of biometric authentication available
    func detectBiometricType() -> BiometricType {
        var error: NSError?
        
        // Check if device can evaluate biometric policy
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // If cannot evaluate, return none
            return .none
        }
        
        // Map LABiometryType to BiometricType
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        case .opticID:
            // Optic ID (Vision Pro) - treat as faceID for compatibility
            return .faceID
        case .none:
            return .none
        @unknown default:
            return .none
        }
    }
    
    /// Checks if biometric authentication is available and enrolled
    ///
    /// - Returns: `true` if biometrics can be used, `false` otherwise
    func isBiometricAvailable() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}

