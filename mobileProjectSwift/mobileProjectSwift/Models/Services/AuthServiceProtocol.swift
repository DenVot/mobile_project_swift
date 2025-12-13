import Foundation

protocol AuthServiceProtocol {
    func login(username: String, password: String) async throws
    func register(username: String, password: String, confirmPassword: String) async throws
    func logout()
    func getCurrentUser() async throws -> User?
    var isAuthenticated: Bool { get }
    var currentUser: User? { get }
}
