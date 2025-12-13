import Foundation

struct CategoryExpenseResponse: Codable {
    let category: Category
    let amount: Double
    let percentage: Double
}

struct MonthlyDataResponse: Codable {
    let month: Int
    let amount: Double
}
