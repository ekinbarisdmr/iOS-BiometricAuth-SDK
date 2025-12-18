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
    /// **reason Parametresi Neden Gerekli?**
    /// iOS, Face ID/Touch ID popup'ında kullanıcıya "neden" bu kimlik doğrulamasının
    /// istendiğini göstermek zorundadır. Bu Apple'ın privacy requirement'ıdır.
    /// Örnek: "Ödeme yapmak için kimliğinizi doğrulayın"
    ///
    /// **Teknik Detay:**
    /// - reason parametresi iOS native popup'ta kullanıcıya gösterilir
    /// - Apple Human Interface Guidelines bu mesajın açık ve anlamlı olmasını gerektirir
    /// - Boş string verilirse SDK default mesaj kullanır: "Kimliğinizi doğrulayın"
    ///
    /// - Parameters:
    ///   - reason: Kimlik doğrulama sebebi (iOS popup'ta gösterilir). Boş verilirse default kullanılır.
    ///   - fallbackTitle: Optional custom title for the fallback button
    ///   - completion: Completion handler called with the authentication result
    public func authenticate(
        reason: String = "Kimliğinizi doğrulayın",
        fallbackTitle: String? = nil,
        completion: @escaping (Result<Void, BiometricError>) -> Void
    ) {
        // Check if any biometric type is available
        let type = availableBiometricType()
        guard type != .none else {
            completion(.failure(.notAvailable))
            return
        }
        
        // Boş veya sadece whitespace içeren reason varsa default kullan
        let reasonToUse = reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Kimliğinizi doğrulayın"
            : reason
        
        authenticator.authenticate(
            reason: reasonToUse,
            fallbackTitle: fallbackTitle,
            completion: completion
        )
    }
}

