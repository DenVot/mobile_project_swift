import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    @ObservedObject var expenseService: ExpenseService
    
    private var category: Category? {
        expenseService.categories.first { $0.id == transaction.categoryId }
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
    return TransactionRow(
        transaction: expenseService.transactions.first!,
        expenseService: expenseService
    )
    .padding()
}

