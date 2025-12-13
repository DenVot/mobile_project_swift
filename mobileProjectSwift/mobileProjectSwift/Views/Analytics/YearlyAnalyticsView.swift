import SwiftUI

struct YearlyAnalyticsView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel
    @State private var selectedCategory: Category? = nil
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    private var yearlyData: [(month: Int, amount: Double)] {
        expenseViewModel.getYearlyData(
            for: selectedYear,
            categoryId: selectedCategory?.id
        )
    }
    
    private var maxAmount: Double {
        yearlyData.map { $0.amount }.max() ?? 1
    }
    
    private var monthNames: [String] {
        ["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"]
    }
    
    private var allMonthsData: [(month: Int, amount: Double)] {
        var result: [(month: Int, amount: Double)] = []
        for month in 1...12 {
            if let existing = yearlyData.first(where: { $0.month == month }) {
                result.append(existing)
            } else {
                result.append((month: month, amount: 0))
            }
        }
        return result
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(String(selectedYear))
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Категория:")
                        .font(.headline)
                    
                    Picker("Категория", selection: $selectedCategory) {
                        Text("Все категории").tag(nil as Category?)
                        ForEach(expenseViewModel.categories) { category in
                            HStack {
                                Circle()
                                    .fill(category.color.swiftUIColor)
                                    .frame(width: 12, height: 12)
                                Text(category.name)
                            }
                            .tag(category as Category?)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Расходы по месяцам")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if maxAmount > 0 {
                        GeometryReader { geometry in
                            let availableWidth = geometry.size.width - 32
                            let spacing: CGFloat = 4
                            let barWidth = (availableWidth - spacing * CGFloat(allMonthsData.count - 1)) / CGFloat(allMonthsData.count)
                            let chartHeight = geometry.size.height - 30
                            
                            VStack(spacing: 8) {
                                HStack(alignment: .bottom, spacing: spacing) {
                                    ForEach(allMonthsData, id: \.month) { data in
                                        VStack(spacing: 0) {
                                            let barHeight = maxAmount > 0 ? chartHeight * CGFloat(data.amount / maxAmount) : 0
                                            
                                            if barHeight > 0 {
                                                RoundedRectangle(cornerRadius: 3)
                                                    .fill(selectedCategory?.color.swiftUIColor ?? Color.blue)
                                                    .frame(
                                                        width: barWidth,
                                                        height: max(barHeight, 2)
                                                    )
                                            } else {
                                                Color.clear
                                                    .frame(width: barWidth, height: 0)
                                            }
                                        }
                                        .frame(width: barWidth, alignment: .bottom)
                                    }
                                }
                                .frame(height: chartHeight, alignment: .bottom)
                                
                                HStack(spacing: spacing) {
                                    ForEach(allMonthsData, id: \.month) { data in
                                        let monthIndex = data.month - 1
                                        Text(monthIndex >= 0 && monthIndex < monthNames.count ? monthNames[monthIndex] : "")
                                            .font(.system(size: 11))
                                            .foregroundColor(.gray)
                                            .frame(width: barWidth)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                    }
                                }
                                .frame(height: 20)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(height: 250)
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "chart.bar")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("Нет данных за \(String(selectedYear)) год")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    let expenseService = ExpenseService()
    let expenseViewModel = ExpenseViewModel(expenseService: expenseService)
    return NavigationStack {
        YearlyAnalyticsView(expenseViewModel: expenseViewModel)
    }
}
