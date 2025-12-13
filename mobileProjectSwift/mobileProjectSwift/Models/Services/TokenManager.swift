import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "jwt_token"
    
    private init() {}
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    var hasToken: Bool {
        return getToken() != nil
    }
}
