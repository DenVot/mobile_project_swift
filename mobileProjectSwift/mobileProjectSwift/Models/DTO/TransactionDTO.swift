import Foundation

struct CreateTransactionRequest: Codable {
    let name: String
    let amount: Double
    let categoryId: UUID
    let date: Date?
    
    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case categoryId
        case date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
        try container.encode(categoryId, forKey: .categoryId)
        
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            try container.encode(formatter.string(from: date), forKey: .date)
        }
    }
}
