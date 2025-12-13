import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let expenseService: ExpenseServiceProtocol
    
    init(expenseService: ExpenseServiceProtocol) {
        self.expenseService = expenseService
        updateState()
    }
    
    func loadData(month: Date? = nil) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await expenseService.loadCategories()
                try await expenseService.loadTransactions(month: month)
                await MainActor.run {
                    updateState()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Ошибка загрузки данных: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func addCategory(_ category: Category) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await expenseService.addCategory(category)
                await MainActor.run {
                    updateState()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Ошибка добавления категории: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func updateCategory(_ category: Category) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await expenseService.updateCategory(category)
                await MainActor.run {
                    updateState()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Ошибка обновления категории: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func deleteCategory(_ category: Category) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await expenseService.deleteCategory(category)
                try await expenseService.loadCategories()
                try await expenseService.loadTransactions(month: nil)
                await MainActor.run {
                    updateState()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Ошибка удаления категории: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func addTransaction(_ transaction: Transaction) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await expenseService.addTransaction(transaction)
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month], from: transaction.date)
                if let monthDate = calendar.date(from: DateComponents(year: components.year, month: components.month)) {
                    try await expenseService.loadTransactions(month: monthDate)
                }
                await MainActor.run {
                    updateState()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Ошибка добавления транзакции: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await expenseService.deleteTransaction(transaction)
                try await expenseService.loadTransactions(month: nil)
                await MainActor.run {
                    updateState()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Ошибка удаления транзакции: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func getTransactions(for month: Date) -> [Transaction] {
        return expenseService.getTransactions(for: month)
    }
    
    func getCategoryExpenses(for month: Date) async -> [(category: Category, amount: Double, percentage: Double)] {
        do {
            return try await expenseService.getCategoryExpenses(for: month)
        } catch {
            await MainActor.run {
                errorMessage = "Ошибка загрузки аналитики: \(error.localizedDescription)"
            }
            return []
        }
    }
    
    func getYearlyData(for year: Int, categoryId: UUID? = nil) async -> [(month: Int, amount: Double)] {
        do {
            return try await expenseService.getYearlyData(for: year, categoryId: categoryId)
        } catch {
            await MainActor.run {
                errorMessage = "Ошибка загрузки годовых данных: \(error.localizedDescription)"
            }
            return []
        }
    }
    
    private func updateState() {
        categories = expenseService.categories
        transactions = expenseService.transactions
    }
}
