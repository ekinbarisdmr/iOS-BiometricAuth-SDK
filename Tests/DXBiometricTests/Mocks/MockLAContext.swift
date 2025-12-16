import Foundation
import LocalAuthentication
@testable import DXBiometric

/// Mock implementation of LAContextProtocol for testing
final class MockLAContext: LAContextProtocol {
    
    // MARK: - Mock Properties
    
    var canEvaluatePolicyReturnValue: Bool = true
    var canEvaluatePolicyError: NSError?
    var biometryType: LABiometryType = .none
    var evaluatePolicyResult: (success: Bool, error: Error?) = (false, nil)
    var localizedFallbackTitle: String?
    
    // MARK: - Call Tracking
    
    var canEvaluatePolicyCalled = false
    var evaluatePolicyCalled = false
    var capturedPolicy: LAPolicy?
    var capturedReason: String?
    
    // MARK: - LAContextProtocol Methods
    
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        canEvaluatePolicyCalled = true
        capturedPolicy = policy
        
        if let mockError = canEvaluatePolicyError {
            error?.pointee = mockError
        }
        
        return canEvaluatePolicyReturnValue
    }
    
    func evaluatePolicy(
        _ policy: LAPolicy,
        localizedReason: String,
        reply: @escaping (Bool, Error?) -> Void
    ) {
        evaluatePolicyCalled = true
        capturedPolicy = policy
        capturedReason = localizedReason
        
        // Simulate async behavior
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            reply(self.evaluatePolicyResult.success, self.evaluatePolicyResult.error)
        }
    }
}

