import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    @ObservedObject var expenseViewModel: ExpenseViewModel
    
    private var category: Category? {
        expenseViewModel.categories.first { $0.id == transaction.categoryId }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.name)
                    .font(.body)
                    .bold()
                
                if let category = category {
                    Text("(\(category.name))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text("\(Int(transaction.amount)) P")
                .font(.body)
                .bold()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    let expenseService = ExpenseService()
    let expenseViewModel = ExpenseViewModel(expenseService: expenseService)
    if let firstTransaction = expenseViewModel.transactions.first {
        return TransactionRow(
            transaction: firstTransaction,
            expenseViewModel: expenseViewModel
        )
        .padding()
    } else {
        return TransactionRow(
            transaction: Transaction(name: "Что-то пошло не так...", amount: 1000, categoryId: UUID()),
            expenseViewModel: expenseViewModel
        )
        .padding()
    }
}

