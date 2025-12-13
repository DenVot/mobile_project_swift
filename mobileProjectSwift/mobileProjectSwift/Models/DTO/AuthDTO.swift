import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let password: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case confirmPassword
    }
}

struct AuthResponse: Codable {
    let user: User
    let token: String
}
