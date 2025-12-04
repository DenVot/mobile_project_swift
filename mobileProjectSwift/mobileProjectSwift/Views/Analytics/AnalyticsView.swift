import SwiftUI

struct AnalyticsView: View {
    @Binding var selectedMonth: Date
    @ObservedObject var expenseService: ExpenseService
    @State private var showAddPurchase = false
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    private var monthTransactions: [Transaction] {
        expenseService.getTransactions(for: selectedMonth)
    }
    
    private var categoryExpenses: [(category: Category, amount: Double, percentage: Double)] {
        expenseService.getCategoryExpenses(for: selectedMonth)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button {
                            selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        
                        Spacer()
                        
                        Text(monthFormatter.string(from: selectedMonth).capitalized)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if !categoryExpenses.isEmpty {
                        PieChartView(categoryExpenses: categoryExpenses)
                            .frame(height: 250)
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(categoryExpenses, id: \.category.id) { item in
                                HStack {
                                    Circle()
                                        .fill(item.category.color.swiftUIColor)
                                        .frame(width: 16, height: 16)
                                    
                                    Text("\(item.category.name): \(Int(item.percentage))%")
                                        .font(.body)
                                }
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "chart.pie")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("В этом месяце не было трат")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    }
                    
                    if !monthTransactions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(monthTransactions) { transaction in
                                TransactionRow(transaction: transaction, expenseService: expenseService)
                            }
                        }
                        .padding(.horizontal)
                    } else if categoryExpenses.isEmpty {
                        Text("Добавьте первую покупку, нажав кнопку \"+\"")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 20)
                    }
                    
                    Spacer()
                        .frame(height: 80)
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showAddPurchase = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $showAddPurchase) {
            AddPurchaseView(expenseService: expenseService, selectedMonth: $selectedMonth)
        }
    }
}

#Preview {
    AnalyticsView(selectedMonth: .constant(Date()), expenseService: ExpenseService())
}

