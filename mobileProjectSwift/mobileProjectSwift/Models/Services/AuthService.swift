import Foundation

class AuthService: AuthServiceProtocol {
    private(set) var isAuthenticated = false
    private(set) var currentUser: User? = nil
    
    private let apiClient = APIClient.shared
    private let tokenManager = TokenManager.shared
    
    init() {
        if tokenManager.hasToken {
            isAuthenticated = true
            Task {
                do {
                    currentUser = try await getCurrentUser()
                } catch {
                    tokenManager.clearToken()
                    isAuthenticated = false
                }
            }
        }
    }
    
    func login(username: String, password: String) async throws {
        let request = LoginRequest(username: username, password: password)
        let response: AuthResponse = try await apiClient.request(
            endpoint: "/auth/login",
            method: "POST",
            body: request
        )
        
        tokenManager.saveToken(response.token)
        currentUser = response.user
        isAuthenticated = true
    }
    
    func register(username: String, password: String, confirmPassword: String) async throws {
        let request = RegisterRequest(username: username, password: password, confirmPassword: confirmPassword)
        let response: AuthResponse = try await apiClient.request(
            endpoint: "/auth/register",
            method: "POST",
            body: request
        )
        
        tokenManager.saveToken(response.token)
        currentUser = response.user
        isAuthenticated = true
    }
    
    func logout() {
        tokenManager.clearToken()
        currentUser = nil
        isAuthenticated = false
    }
    
    func getCurrentUser() async throws -> User? {
        let user: User = try await apiClient.request(endpoint: "/auth/me", method: "GET")
        currentUser = user
        return user
    }
}

