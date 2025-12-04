import SwiftUI

struct AddPurchaseView: View {
    @ObservedObject var expenseService: ExpenseService
    @Binding var selectedMonth: Date
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var selectedCategoryId: UUID? = nil
    
    private var selectedCategory: Category? {
        if let id = selectedCategoryId {
            return expenseService.categories.first { $0.id == id }
        }
        return nil
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !price.isEmpty && Double(price) != nil && selectedCategoryId != nil
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Название")
                        .font(.headline)
                    
                    TextField("Введите название покупки", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Цена (руб)")
                        .font(.headline)
                    
                    TextField("0", text: $price)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Категория")
                        .font(.headline)
                    
                    if expenseService.categories.isEmpty {
                        Text("Нет доступных категорий")
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    } else {
                        Picker("Категория", selection: $selectedCategoryId) {
                            Text("Выберите категорию").tag(nil as UUID?)
                            ForEach(expenseService.categories) { category in
                                HStack {
                                    Circle()
                                        .fill(category.color.swiftUIColor)
                                        .frame(width: 12, height: 12)
                                    Text(category.name)
                                }
                                .tag(category.id as UUID?)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    addPurchase()
                } label: {
                    Text("Добавить")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!isFormValid)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Новая покупка")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addPurchase() {
        guard let priceValue = Double(price),
              let categoryId = selectedCategoryId else {
            return
        }
        
        let calendar = Calendar.current
        let transactionDate: Date
        
        if calendar.isDate(selectedMonth, equalTo: Date(), toGranularity: .month) {
            transactionDate = Date()
        } else {
            let components = calendar.dateComponents([.year, .month], from: selectedMonth)
            transactionDate = calendar.date(from: DateComponents(year: components.year, month: components.month, day: 1)) ?? Date()
        }
        
        let transaction = Transaction(
            name: name,
            amount: priceValue,
            categoryId: categoryId,
            date: transactionDate
        )
        
        expenseService.addTransaction(transaction)
        dismiss()
    }
}

#Preview {
    AddPurchaseView(
        expenseService: ExpenseService(),
        selectedMonth: .constant(Date())
    )
}

