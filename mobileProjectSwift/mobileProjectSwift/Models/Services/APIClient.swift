import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    case networkError(Error)
}

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "http://localhost:8080/api"
    private let tokenManager = TokenManager.shared
    
    private init() {}
    
    private func createRequest(url: URL, method: String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = tokenManager.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var requestBody: Data?
        if let body = body {
            requestBody = try JSONEncoder().encode(body)
        }
        
        let request = createRequest(url: url, method: method, body: requestBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.networkError(NSError(domain: "Invalid response", code: -1))
            }
            
            if httpResponse.statusCode == 401 {
                tokenManager.clearToken()
                throw APIError.unauthorized
            }
            
            if httpResponse.statusCode >= 400 {
                var errorMessage = "Ошибка сервера"
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    errorMessage = errorResponse.error
                } else if let errorString = String(data: data, encoding: .utf8), !errorString.isEmpty {
                    errorMessage = errorString
                }
                throw APIError.serverError(errorMessage)
            }
            
            if httpResponse.statusCode == 204 || data.isEmpty {
                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                }
                throw APIError.noData
            }
            
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone.current
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "nil")")
                throw APIError.decodingError
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}

struct EmptyResponse: Codable {}

struct ErrorResponse: Codable {
    let error: String
}
