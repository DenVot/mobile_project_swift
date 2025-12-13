import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var selectedTab: MainTab = .monthly
    @Published var selectedMonth = Date()
    
    let authViewModel: AuthViewModel
    let expenseViewModel: ExpenseViewModel
    
    init(authViewModel: AuthViewModel, expenseViewModel: ExpenseViewModel) {
        self.authViewModel = authViewModel
        self.expenseViewModel = expenseViewModel
    }
    
    func selectTab(_ tab: MainTab) {
        selectedTab = tab
    }
    
    func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
}
