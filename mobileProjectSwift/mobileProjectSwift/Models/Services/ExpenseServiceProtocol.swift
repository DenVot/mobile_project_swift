import Foundation

protocol ExpenseServiceProtocol {
    var categories: [Category] { get }
    var transactions: [Transaction] { get }
    
    func loadCategories() async throws
    func loadTransactions(month: Date?) async throws
    func addCategory(_ category: Category) async throws
    func updateCategory(_ category: Category) async throws
    func deleteCategory(_ category: Category) async throws
    func addTransaction(_ transaction: Transaction) async throws
    func deleteTransaction(_ transaction: Transaction) async throws
    func getTransactions(for month: Date) -> [Transaction]
    func getCategoryExpenses(for month: Date) async throws -> [(category: Category, amount: Double, percentage: Double)]
    func getYearlyData(for year: Int, categoryId: UUID?) async throws -> [(month: Int, amount: Double)]
}
