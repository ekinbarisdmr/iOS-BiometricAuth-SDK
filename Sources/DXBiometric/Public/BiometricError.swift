import Foundation

/// Errors that can occur during biometric authentication
public enum BiometricError: Error {
    /// Biometric authentication is not available on this device
    case notAvailable
    
    /// No biometric data is enrolled on this device
    case notEnrolled
    
    /// Biometric authentication is locked due to too many failed attempts
    case lockout
    
    /// User cancelled the authentication
    case cancelled
    
    /// User chose to use the fallback method
    case fallback
    
    /// A system error occurred
    case systemError(String)
    
    /// An unknown error occurred
    case unknown
}

// MARK: - LocalizedError
extension BiometricError: LocalizedError {
    public var errorDescription: String? {
        return localizedDescription
    }
    
    public var localizedDescription: String {
        // TODO: Load from SDK bundle Resources
        switch self {
        case .notAvailable:
            return NSLocalizedString("biometric_error_not_available", bundle: .module, comment: "")
        case .notEnrolled:
            return NSLocalizedString("biometric_error_not_enrolled", bundle: .module, comment: "")
        case .lockout:
            return NSLocalizedString("biometric_error_lockout", bundle: .module, comment: "")
        case .cancelled:
            return NSLocalizedString("biometric_error_cancelled", bundle: .module, comment: "")
        case .fallback:
            return NSLocalizedString("biometric_error_fallback", bundle: .module, comment: "")
        case .systemError(let message):
            return String(format: NSLocalizedString("biometric_error_system", bundle: .module, comment: ""), message)
        case .unknown:
            return NSLocalizedString("biometric_error_unknown", bundle: .module, comment: "")
        }
    }
}

