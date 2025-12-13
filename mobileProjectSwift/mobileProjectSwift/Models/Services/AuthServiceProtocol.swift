import Foundation

protocol AuthServiceProtocol {
    func login(username: String, password: String)
    func register(username: String, password: String, confirmPassword: String)
    func logout()
    var isAuthenticated: Bool { get }
    var currentUser: User? { get }
}
