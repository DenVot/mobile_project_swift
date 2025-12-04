import Foundation

class ExpenseService: ObservableObject {
    @Published var categories: [Category] = []
    @Published var transactions: [Transaction] = []
    
    init() {
        let sneakersCategory = Category(name: "Кроссовки", color: .green)
        let groceriesCategory = Category(name: "Продукты", color: .purple)
        
        categories = [sneakersCategory, groceriesCategory]
        
        let now = Date()
        let calendar = Calendar.current
        let mayDate = calendar.date(from: DateComponents(year: 2025, month: 5, day: 15)) ?? now
        
        transactions = [
            Transaction(name: "Nike", amount: 10000, categoryId: sneakersCategory.id, date: mayDate),
            Transaction(name: "Поход в магазин", amount: 10000, categoryId: groceriesCategory.id, date: mayDate)
        ]
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
        }
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        transactions.removeAll { $0.categoryId == category.id }
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }
    
    func deleteTransaction(_ transaction: Transaction) {
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
    
    func getCategoryExpenses(for month: Date) -> [(category: Category, amount: Double, percentage: Double)] {
        let monthTransactions = getTransactions(for: month)
        let total = monthTransactions.reduce(0) { $0 + $1.amount }
        
        guard total > 0 else { return [] }
        
        var categoryAmounts: [UUID: Double] = [:]
        
        for transaction in monthTransactions {
            categoryAmounts[transaction.categoryId, default: 0] += transaction.amount
        }
        
        return categoryAmounts.compactMap { categoryId, amount in
            guard let category = categories.first(where: { $0.id == categoryId }) else { return nil }
            let percentage = (amount / total) * 100
            return (category: category, amount: amount, percentage: percentage)
        }.sorted { $0.amount > $1.amount }
    }
    
    func getYearlyData(for year: Int, categoryId: UUID? = nil) -> [(month: Int, amount: Double)] {
        let calendar = Calendar.current
        var monthlyData: [Int: Double] = [:]
        
        for month in 1...12 {
            monthlyData[month] = 0
        }
        
        let filteredTransactions = transactions.filter { transaction in
            let transactionYear = calendar.component(.year, from: transaction.date)
            if transactionYear != year {
                return false
            }
            if let categoryId = categoryId {
                return transaction.categoryId == categoryId
            }
            return true
        }
        
        for transaction in filteredTransactions {
            let month = calendar.component(.month, from: transaction.date)
            monthlyData[month, default: 0] += transaction.amount
        }
        
        return monthlyData.map { (month: $0.key, amount: $0.value) }
            .sorted { $0.month < $1.month }
    }
}

