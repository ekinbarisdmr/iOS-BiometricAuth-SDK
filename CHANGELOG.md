# Changelog

All notable changes to DXBiometric SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.1] - 2025-12-18

### Fixed
- **CocoaPods + `use_frameworks!` rsync/_CodeSignature permission errors**
  - Added `spec.static_framework = true` to force static linking even when host app uses `use_frameworks!`
  - Added `spec.pod_target_xcconfig` to disable code signing for pod target only
  - This prevents `[CP] Embed Pods Frameworks` phase from encountering:
    - `mkpathat: Operation not permitted` on `_CodeSignature/`
    - `mkstempat: Operation not permitted` on framework binary
    - `utimensat(2): No such file or directory`
    - `rsync unexpected end of file` errors
  - These settings apply ONLY to the pod target and do NOT affect host app code signing

### Changed
- Updated repository URLs from `Definex-Mobile` to `ekinbarisdmr` personal repo
- Updated author information to personal contact

### Technical Details
**Why static framework?**
- Static frameworks are compiled directly into the host app binary
- No separate framework bundle needs to be embedded/copied at build time
- Eliminates rsync operations on framework bundles during `[CP] Embed Pods Frameworks`
- Compatible with both `use_frameworks!` and non-modular projects

**Why disable code signing on pod target?**
- Pod targets don't need their own code signature (host app signs everything)
- Prevents CocoaPods from generating `_CodeSignature/` directory in framework bundle
- Avoids rsync permission issues when copying framework artifacts
- Host app's code signing remains completely unaffected

---

## [1.0.0] - 2025-01-XX

### Added
- Initial release of DXBiometric SDK
- Face ID and Touch ID authentication support
- iOS 12.0+ compatibility
- Swift 6 concurrency support (@Sendable closures)
- Protocol-based testable architecture
- Comprehensive error handling with semantic error types
- Thread-safe operations (main thread dispatch)
- SPM, CocoaPods, and Carthage distribution support
- Public API: `DXBiometricAuth`, `BiometricType`, `BiometricError`
- Internal implementation with access control protection
- Default reason text fallback ("Kimliğinizi doğrulayın")
- Comprehensive documentation and best practices guide

---

[1.0.1]: https://github.com/ekinbarisdmr/iOS-BiometricAuth-SDK/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/ekinbarisdmr/iOS-BiometricAuth-SDK/releases/tag/1.0.0

