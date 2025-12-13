import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
        updateState()
    }
    
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authService.login(username: username, password: password)
                await MainActor.run {
                    updateState()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .unauthorized:
                            errorMessage = "Неверное имя пользователя или пароль"
                        case .serverError(let message):
                            errorMessage = message
                        default:
                            errorMessage = "Ошибка подключения к серверу"
                        }
                    } else {
                        errorMessage = "Произошла ошибка: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func register(username: String, password: String, confirmPassword: String) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authService.register(username: username, password: password, confirmPassword: confirmPassword)
                await MainActor.run {
                    updateState()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .serverError(let message):
                            errorMessage = message
                        default:
                            errorMessage = "Ошибка подключения к серверу"
                        }
                    } else {
                        errorMessage = "Произошла ошибка: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func logout() {
        authService.logout()
        updateState()
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func updateState() {
        isAuthenticated = authService.isAuthenticated
        currentUser = authService.currentUser
    }
}
