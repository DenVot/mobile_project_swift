import Foundation

class AuthService: AuthServiceProtocol {
    private(set) var isAuthenticated = false
    private(set) var currentUser: User? = nil
    
    func login(username: String, password: String) {
        let user = User(id: UUID(), name: username)
        currentUser = user
        isAuthenticated = true
    }
    
    func register(username: String, password: String, confirmPassword: String) {
        let user = User(id: UUID(), name: username)
        currentUser = user
        isAuthenticated = true
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
    }
}

