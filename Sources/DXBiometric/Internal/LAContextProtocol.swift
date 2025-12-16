import Foundation
import LocalAuthentication

/// Protocol abstraction for LAContext to enable testing
///
/// This protocol wraps the essential LAContext methods needed for biometric authentication,
/// allowing us to inject mock implementations in unit tests.
@available(iOS 11.0, macOS 10.13.2, *)
internal protocol LAContextProtocol {
    /// Evaluates the specified policy
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    
    /// Returns the biometry type available on the device
    var biometryType: LABiometryType { get }
    
    /// Evaluates the policy asynchronously
    func evaluatePolicy(
        _ policy: LAPolicy,
        localizedReason: String,
        reply: @escaping (Bool, Error?) -> Void
    )
    
    /// Custom title for the fallback button
    var localizedFallbackTitle: String? { get set }
}

// MARK: - LAContext Conformance
@available(iOS 11.0, macOS 10.13.2, *)
extension LAContext: LAContextProtocol {
    // LAContext already conforms to this protocol
}

