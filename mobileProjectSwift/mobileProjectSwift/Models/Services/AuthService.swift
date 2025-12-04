import Foundation

class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User? = nil
    
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

