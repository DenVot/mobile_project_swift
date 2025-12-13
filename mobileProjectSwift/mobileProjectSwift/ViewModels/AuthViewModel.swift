import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User? = nil
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
        updateState()
    }
    
    func login(username: String, password: String) {
        authService.login(username: username, password: password)
        updateState()
    }
    
    func register(username: String, password: String, confirmPassword: String) {
        authService.register(username: username, password: password, confirmPassword: confirmPassword)
        updateState()
    }
    
    func logout() {
        authService.logout()
        updateState()
    }
    
    private func updateState() {
        isAuthenticated = authService.isAuthenticated
        currentUser = authService.currentUser
    }
}
