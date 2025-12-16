import XCTest
@testable import DXBiometric

/// Tests for DXBiometricAuth facade
final class DXBiometricAuthTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: DXBiometricAuth!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        sut = DXBiometricAuth()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSharedInstanceExists() {
        // TODO: Test that shared instance exists and is accessible
        XCTAssertNotNil(DXBiometricAuth.shared)
    }
    
    func testAvailableBiometricType() {
        // TODO: Test biometric type detection
        let type = sut.availableBiometricType()
        XCTAssertNotNil(type)
    }
    
    func testIsBiometricAvailable() {
        // TODO: Test availability check
        let isAvailable = sut.isBiometricAvailable()
        XCTAssertNotNil(isAvailable)
    }
    
    func testAuthenticate() {
        // TODO: Test authentication with mock LAContext
        let expectation = expectation(description: "Authentication completes")
        
        sut.authenticate(reason: "Test", fallbackTitle: nil) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

