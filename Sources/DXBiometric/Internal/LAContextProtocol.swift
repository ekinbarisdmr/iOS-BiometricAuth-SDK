import Foundation
import LocalAuthentication

/// Protocol abstraction for LAContext to enable testing
///
/// This protocol wraps the essential LAContext methods needed for biometric authentication,
/// allowing us to inject mock implementations in unit tests.
///
/// **Technical Note - Sendability:**
/// iOS 12 deployment target kullanıyoruz, ancak Swift 6 concurrency uyumluluğu için
/// evaluatePolicy closure'ını @Sendable olarak işaretliyoruz. Bu, closure'ın thread-safe
/// olduğunu garanti eder ve modern Swift concurrency modeline uyum sağlar.
internal protocol LAContextProtocol {
    /// Evaluates the specified policy
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    
    /// Returns the biometry type available on the device
    var biometryType: LABiometryType { get }
    
    /// Evaluates the policy asynchronously
    func evaluatePolicy(
        _ policy: LAPolicy,
        localizedReason: String,
        reply: @escaping @Sendable (Bool, Error?) -> Void
    )
    
    /// Custom title for the fallback button
    var localizedFallbackTitle: String? { get set }
}

// MARK: - LAContext Conformance
extension LAContext: LAContextProtocol {}

