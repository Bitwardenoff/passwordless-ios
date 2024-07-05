import Foundation

// MARK: PasswordlessConfig

/// Configuration items needed to initialize a PasswordlessClient.
///
public struct PasswordlessConfig {
    /// The url to the API server.
    public let apiUrl: String

    /// The API key needed to access the API server.
    public let apiKey: String

    /// The relying party identifier.
    public let rpId: String

    /// The origin of the requesting application.
    public let origin: String

    /// Initializes a PasswordlessConfig.
    ///
    /// - Parameters:
    ///    - apiUrl: The url to the API server.
    ///    - apiKey: The API key needed to access the API server.
    ///    - rpId: The relying party identifier.
    ///    - origin: The origin of the requesting application.
    ///
    public init(
        apiUrl: String,
        apiKey: String,
        rpId: String,
        origin: String
    ) {
        self.apiUrl = apiUrl
        self.apiKey = apiKey
        self.rpId = rpId
        self.origin = origin
    }
}
