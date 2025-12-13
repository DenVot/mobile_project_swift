import Foundation

class ExpenseService: ExpenseServiceProtocol {
    private(set) var categories: [Category] = []
    private(set) var transactions: [Transaction] = []
    
    private let apiClient = APIClient.shared
    private let categoryService = CategoryService()
    
    func loadCategories() async throws {
        categories = try await categoryService.getAllCategories()
    }
    
    func loadTransactions(month: Date? = nil) async throws {
        var endpoint = "/transactions"
        if let month = month {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            let dateString = formatter.string(from: month)
            if let encodedDate = dateString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                endpoint += "?month=\(encodedDate)"
            } else {
                endpoint += "?month=\(dateString)"
            }
        }
        
        transactions = try await apiClient.request(endpoint: endpoint, method: "GET")
    }
    
    func addCategory(_ category: Category) async throws {
        let createdCategory = try await categoryService.createCategory(category)
        if let index = categories.firstIndex(where: { $0.id == createdCategory.id }) {
            categories[index] = createdCategory
        } else {
            categories.append(createdCategory)
        }
    }
    
    func updateCategory(_ category: Category) async throws {
        if let updatedCategory = try await categoryService.updateCategory(category) {
            if let index = categories.firstIndex(where: { $0.id == updatedCategory.id }) {
                categories[index] = updatedCategory
            }
        }
    }
    
    func deleteCategory(_ category: Category) async throws {
        try await categoryService.deleteCategory(category)
        categories.removeAll { $0.id == category.id }
        transactions.removeAll { $0.categoryId == category.id }
    }
    
    func addTransaction(_ transaction: Transaction) async throws {
        let request = CreateTransactionRequest(
            name: transaction.name,
            amount: transaction.amount,
            categoryId: transaction.categoryId,
            date: transaction.date
        )
        let createdTransaction: Transaction = try await apiClient.request(
            endpoint: "/transactions",
            method: "POST",
            body: request
        )
        transactions.append(createdTransaction)
    }
    
    func deleteTransaction(_ transaction: Transaction) async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "/transactions/\(transaction.id.uuidString)",
            method: "DELETE"
        )
        transactions.removeAll { $0.id == transaction.id }
    }
    
    func getTransactions(for month: Date) -> [Transaction] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: month)
        
        return transactions.filter { transaction in
            let transactionComponents = calendar.dateComponents([.year, .month], from: transaction.date)
            return transactionComponents.year == components.year && transactionComponents.month == components.month
        }
    }
    
    func getCategoryExpenses(for month: Date) async throws -> [(category: Category, amount: Double, percentage: Double)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        let dateString = formatter.string(from: month)
        let encodedDate = dateString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? dateString
        
        let response: [CategoryExpenseResponse] = try await apiClient.request(
            endpoint: "/analytics/monthly?month=\(encodedDate)",
            method: "GET"
        )
        
        return response.map { response in
            (category: response.category, amount: response.amount, percentage: response.percentage)
        }
    }
    
    func getYearlyData(for year: Int, categoryId: UUID? = nil) async throws -> [(month: Int, amount: Double)] {
        var endpoint = "/analytics/yearly?year=\(year)"
        if let categoryId = categoryId {
            endpoint += "&categoryId=\(categoryId.uuidString)"
        }
        
        let response: [MonthlyDataResponse] = try await apiClient.request(
            endpoint: endpoint,
            method: "GET"
        )
        
        return response.map { response in
            (month: response.month, amount: response.amount)
        }
    }
}

