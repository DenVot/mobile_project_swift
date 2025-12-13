import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var transactions: [Transaction] = []
    
    private let expenseService: ExpenseServiceProtocol
    
    init(expenseService: ExpenseServiceProtocol) {
        self.expenseService = expenseService
        updateState()
    }
    
    func addCategory(_ category: Category) {
        expenseService.addCategory(category)
        updateState()
    }
    
    func updateCategory(_ category: Category) {
        expenseService.updateCategory(category)
        updateState()
    }
    
    func deleteCategory(_ category: Category) {
        expenseService.deleteCategory(category)
        updateState()
    }
    
    func addTransaction(_ transaction: Transaction) {
        expenseService.addTransaction(transaction)
        updateState()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        expenseService.deleteTransaction(transaction)
        updateState()
    }
    
    func getTransactions(for month: Date) -> [Transaction] {
        return expenseService.getTransactions(for: month)
    }
    
    func getCategoryExpenses(for month: Date) -> [(category: Category, amount: Double, percentage: Double)] {
        return expenseService.getCategoryExpenses(for: month)
    }
    
    func getYearlyData(for year: Int, categoryId: UUID? = nil) -> [(month: Int, amount: Double)] {
        return expenseService.getYearlyData(for: year, categoryId: categoryId)
    }
    
    private func updateState() {
        categories = expenseService.categories
        transactions = expenseService.transactions
    }
}
