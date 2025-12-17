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
        ) { success, error in
            // Ensure completion is called on main thread
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                } else {
                    // Authentication failed - map error
                    let biometricError = Self.mapError(error)
                    completion(.failure(biometricError))
                }
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
        case .userCancel:
            // Kullanıcı Face ID/Touch ID popup'ında "İptal" butonuna bastı
            // App tarafı: Sessizce handle edilebilir, tekrar giriş ekranı gösterilebilir
            return .cancelled
            
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
            // Kullanıcı yanlış parmak/yüz gösterdi (3-5 deneme hakkı var)
            // iOS otomatik tekrar dener, bu hata genelde son denemeden sonra gelir
            // App tarafı: "Kimlik doğrulama başarısız" mesajı gösterebilir
            return .systemError("Authentication failed")
            
        case .appCancel, .systemCancel:
            // App kod tarafından iptal etti (LAContext.invalidate()) VEYA
            // Sistem iptal etti (telefon kilitlendiyse, app background'a gittiyse)
            // App tarafı: .cancelled ile aynı şekilde handle edilebilir
            return .cancelled
            
        case .invalidContext:
            // LAContext nesnesi geçersiz durumda (nadir, SDK bug'ı olabilir)
            // App tarafı: Tekrar deneme butonu sunabilir
            return .systemError("Invalid context")
            
        case .passcodeNotSet:
            // Cihazda passcode/PIN ayarlanmamış (Face ID/Touch ID için gerekli)
            // App tarafı: Kullanıcıya önce cihaz şifresi ayarlaması gerektiğini söylemeli
            return .notEnrolled
            
        default:
            // Bilinmeyen LAError kodu (gelecek iOS versiyonlarında yeni kodlar eklenebilir)
            // App tarafı: Generic error mesajı gösterebilir
            return .unknown
        }
    }
}

