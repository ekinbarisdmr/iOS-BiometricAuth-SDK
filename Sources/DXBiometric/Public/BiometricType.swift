import Foundation

/// Represents the type of biometric authentication available on the device
public enum BiometricType {
    /// Face ID is available
    case faceID
    
    /// Touch ID is available
    case touchID
    
    /// No biometric authentication is available
    case none
}

