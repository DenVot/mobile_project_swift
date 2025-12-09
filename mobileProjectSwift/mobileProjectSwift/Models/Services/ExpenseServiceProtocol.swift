import Foundation

protocol ExpenseServiceProtocol {
    var categories: [Category] { get }
    var transactions: [Transaction] { get }
    
    func addCategory(_ category: Category)
    func updateCategory(_ category: Category)
    func deleteCategory(_ category: Category)
    func addTransaction(_ transaction: Transaction)
    func deleteTransaction(_ transaction: Transaction)
    func getTransactions(for month: Date) -> [Transaction]
    func getCategoryExpenses(for month: Date) -> [(category: Category, amount: Double, percentage: Double)]
    func getYearlyData(for year: Int, categoryId: UUID?) -> [(month: Int, amount: Double)]
}
