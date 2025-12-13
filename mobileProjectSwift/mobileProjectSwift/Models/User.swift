import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
