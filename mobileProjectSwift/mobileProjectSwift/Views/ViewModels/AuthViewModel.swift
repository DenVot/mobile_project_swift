import Foundation

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User? = nil
    
    func login(username: String, password: String) {
        if !username.isEmpty && !password.isEmpty {
            currentUser = User(id: UUID(), name: username)
            isAuthenticated = true
        }
    }
    
    func register(username: String, password: String, confirmPassword: String) {
        if !username.isEmpty && password == confirmPassword {
            currentUser = User(id: UUID(), name: username)
            isAuthenticated = true
        }
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
    }
}

