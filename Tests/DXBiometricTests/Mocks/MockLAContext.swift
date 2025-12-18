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
    
    // Support for multiple evaluatePolicy calls with different results
    var evaluatePolicyResults: [(success: Bool, error: Error?)] = []
    private var evaluatePolicyCallIndex: Int = 0
    
    // MARK: - Call Tracking
    
    var canEvaluatePolicyCalled = false
    var evaluatePolicyCalled = false
    var evaluatePolicyCallCount = 0
    var capturedPolicy: LAPolicy?
    var capturedReason: String?
    var capturedPolicies: [LAPolicy] = []
    var capturedReasons: [String] = []
    
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
        evaluatePolicyCallCount += 1
        capturedPolicy = policy
        capturedReason = localizedReason
        capturedPolicies.append(policy)
        capturedReasons.append(localizedReason)
        
        // Use sequential results if provided, otherwise use single result
        let result: (success: Bool, error: Error?)
        if !evaluatePolicyResults.isEmpty {
            result = evaluatePolicyResults[evaluatePolicyCallIndex]
            evaluatePolicyCallIndex = min(evaluatePolicyCallIndex + 1, evaluatePolicyResults.count - 1)
        } else {
            result = evaluatePolicyResult
        }
        
        // Call reply immediately for deterministic testing
        reply(result.success, result.error)
    }
    
    // MARK: - Helper Methods
    
    /// Reset call tracking for new test
    func reset() {
        canEvaluatePolicyCalled = false
        evaluatePolicyCalled = false
        evaluatePolicyCallCount = 0
        evaluatePolicyCallIndex = 0
        capturedPolicy = nil
        capturedReason = nil
        capturedPolicies.removeAll()
        capturedReasons.removeAll()
        evaluatePolicyResults.removeAll()
    }
}

