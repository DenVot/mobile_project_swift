import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "jwt_token"
    private let keychainHelper = KeychainHelper.shared
    
    private init() {}
    
    func saveToken(_ token: String) {
        _ = keychainHelper.save(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return keychainHelper.get(forKey: tokenKey)
    }
    
    func clearToken() {
        _ = keychainHelper.delete(forKey: tokenKey)
    }
    
    var hasToken: Bool {
        return keychainHelper.hasValue(forKey: tokenKey)
    }
}
