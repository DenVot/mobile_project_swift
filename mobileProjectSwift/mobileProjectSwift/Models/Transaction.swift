import Foundation

struct Transaction: Identifiable {
    let id: UUID
    var name: String
    var amount: Double
    var categoryId: UUID
    var date: Date
    
    init(id: UUID = UUID(), name: String, amount: Double, categoryId: UUID, date: Date = Date()) {
        self.id = id
        self.name = name
        self.amount = amount
        self.categoryId = categoryId
        self.date = date
    }
}

