import Foundation

struct Transaction: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var amount: Double
    var categoryId: UUID
    var date: Date
    let userId: UUID?
    
    init(id: UUID = UUID(), name: String, amount: Double, categoryId: UUID, date: Date = Date(), userId: UUID? = nil) {
        self.id = id
        self.name = name
        self.amount = amount
        self.categoryId = categoryId
        self.date = date
        self.userId = userId
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case categoryId
        case date
        case userId
    }
}

