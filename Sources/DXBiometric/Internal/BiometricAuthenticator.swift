import Foundation
import LocalAuthentication

/// Handles biometric authentication operations
///
/// This class wraps LocalAuthentication framework and provides
/// a clean interface for performing biometric authentication.
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
    /// **Teknik Detay:**
    /// - iOS native prompt'u zaten 2-3 deneme hakkı verir (Face ID/Touch ID)
    /// - SDK tarafında ekstra retry yapmaya gerek yok
    /// - Tek evaluatePolicy çağrısı yapılır
    ///
    /// **Passcode Fallback:**
    /// - Uses .deviceOwnerAuthenticationWithBiometrics policy (no passcode fallback)
    /// - Sets localizedFallbackTitle to empty string to hide fallback button
    /// - fallbackTitle parametresi ignore edilir (passcode disabled)
    ///
    /// - Parameters:
    ///   - reason: The reason shown to the user for authentication
    ///   - fallbackTitle: Optional custom title for the fallback button (ignored - passcode disabled)
    ///   - completion: Completion handler with Result<Void, BiometricError>
    func authenticate(
        reason: String,
        fallbackTitle: String?,
        completion: @escaping (Result<Void, BiometricError>) -> Void
    ) {
        // Create a new context for this authentication
        var context = contextFactory()
        
        // Set fallback title to empty string to hide passcode fallback button
        // This ensures no passcode option appears in the UI
        // Note: fallbackTitle parameter is ignored to enforce passcode-free policy
        context.localizedFallbackTitle = ""
        
        // Use flag to ensure completion is called exactly once
        var isFinished = false
        let finish: (Result<Void, BiometricError>) -> Void = { result in
            guard !isFinished else { return }
            isFinished = true
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        // Evaluate biometrics-only policy (no passcode fallback)
        // iOS will handle retry attempts (2-3 tries) within the native prompt
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        ) { success, error in
            if success {
                finish(.success(()))
            } else {
                // Authentication failed - map error
                let biometricError = Self.mapError(error)
                finish(.failure(biometricError))
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Maps LAError to BiometricError
    ///
    /// **Teknik Not:**
    /// iOS LocalAuthentication framework'ünden gelen LAError kodlarını
    /// SDK'nın semantic BiometricError type'larına dönüştürür.
    ///
    /// - Parameter error: The error from LocalAuthentication
    /// - Returns: Corresponding BiometricError
    private static func mapError(_ error: Error?) -> BiometricError {
        guard let error = error else { return .unknown }

        let nsError = error as NSError

        guard nsError.domain == LAError.errorDomain else {
            return .systemError(nsError.localizedDescription)
        }

        let laErrorCode = LAError.Code(rawValue: nsError.code)
        
        switch laErrorCode {
        case .userFallback:
            // Kullanıcı popup'ta "Şifre ile giriş yap" gibi fallback seçeneğini seçti
            // App tarafı: Alternatif auth yöntemi (PIN, password) gösterebilir
            return .fallback
            
        case .biometryNotAvailable:
            // Cihazda Face ID/Touch ID donanımı yok VEYA kullanıcı Ayarlar'dan izni kapattı
            // App tarafı: Alternatif auth yöntemi sunmalı (PIN, password zorunlu)
            return .notAvailable
            
        case .biometryNotEnrolled:
            // Cihazda Face ID/Touch ID var ama kullanıcı kayıt yapmamış
            // App tarafı: Kullanıcıyı Ayarlar'a yönlendirebilir veya alternatif auth sunabilir
            return .notEnrolled
            
        case .biometryLockout:
            // Çok fazla başarısız deneme yapıldı, Face ID/Touch ID kilitlendi
            // App tarafı: Kullanıcıya cihaz şifresi ile unlock etmesi gerektiğini söylemeli
            return .lockout
            
        case .authenticationFailed:
            // Kullanıcı yanlış parmak/yüz gösterdi
            // SDK bu durumda 2. deneme yapar (retry logic)
            // App tarafı: "Kimlik doğrulama başarısız" mesajı gösterebilir
            return .authenticationFailed
            
        case .appCancel, .systemCancel, .userCancel:
            // App kod tarafından iptal etti (LAContext.invalidate()) VEYA
            // Sistem iptal etti (telefon kilitlendiyse, app background'a gittiyse)
            // App tarafı: .cancelled ile aynı şekilde handle edilebilir
            return .cancelled
            
        default:
            // Bilinmeyen LAError kodu (gelecek iOS versiyonlarında yeni kodlar eklenebilir)
            // App tarafı: Generic error mesajı gösterebilir
            return .unknown
        }
    }
}

