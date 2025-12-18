import Foundation

/// Errors that can occur during biometric authentication
///
/// **SDK Tasarım Kararı - Error Mesajları:**
///
/// Bu SDK semantic error type'lar döner, localized mesaj üretmez.
/// Neden?
/// 1. iOS zaten Face ID/Touch ID popup'ında kullanıcıya mesaj gösterir
/// 2. App tarafı kendi UI/UX'ine göre mesaj göstermek isteyebilir
/// 3. SDK'nın localization yönetmesi ekstra complexity yaratır
/// 4. Her app farklı tone of voice kullanabilir (formal, casual, etc.)
///
/// **Önerilen Kullanım:**
/// ```swift
/// DXBiometricAuth.shared.authenticate { result in
///     switch result {
///     case .success:
///         // Handle success
///     case .failure(let error):
///         switch error {
///         case .notAvailable:
///             showAlert("Face ID kullanılamıyor")
///         case .cancelled:
///             // Sessizce handle et
///         }
///     }
/// }
/// ```
public enum BiometricError: Error, Equatable {
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
    
    /// Biometric authentication failed (wrong face/fingerprint)
    case authenticationFailed
    
    /// A system error occurred
    case systemError(String)
    
    /// An unknown error occurred
    case unknown
}

// MARK: - Error Identifiers
extension BiometricError {
    /// Returns a stable string identifier for the error type
    ///
    /// **Teknik Not:**
    /// App tarafı bu identifier'ı kullanarak kendi localization'ını yapabilir.
    /// Bu yaklaşım SDK'yı lightweight tutar ve app'e esneklik sağlar.
    public var identifier: String {
        switch self {
        case .notAvailable: return "biometric_error_not_available"
        case .notEnrolled: return "biometric_error_not_enrolled"
        case .lockout: return "biometric_error_lockout"
        case .cancelled: return "biometric_error_cancelled"
        case .fallback: return "biometric_error_fallback"
        case .authenticationFailed: return "biometric_error_authentication_failed"
        case .systemError: return "biometric_error_system"
        case .unknown: return "biometric_error_unknown"
        }
    }
}

