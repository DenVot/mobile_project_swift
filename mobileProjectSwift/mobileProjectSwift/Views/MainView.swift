import SwiftUI

enum MainTab: CaseIterable {
    case monthly
    case yearly
    case profile
    case categories
    
    func title(authViewModel: AuthViewModel) -> String {
        switch self {
        case .monthly:
            return "Месяц"
        case .yearly:
            return "Аналитика за год"
        case .profile:
            return authViewModel.currentUser?.name ?? "Профиль"
        case .categories:
            return "Категории"
        }
    }
}

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @State private var navigationPath = NavigationPath()
    
    init(authViewModel: AuthViewModel, expenseViewModel: ExpenseViewModel) {
        _viewModel = StateObject(wrappedValue: MainViewModel(authViewModel: authViewModel, expenseViewModel: expenseViewModel))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(MainTab.allCases, id: \.self) { tab in
                        Button {
                            viewModel.selectTab(tab)
                        } label: {
                            Text(tab.title(authViewModel: viewModel.authViewModel))
                                .font(.system(size: 16))
                                .foregroundColor(viewModel.selectedTab == tab ? .blue : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(viewModel.selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear)
                        }
                    }
                }
                .background(Color.gray.opacity(0.1))
                
                Group {
                    switch viewModel.selectedTab {
                    case .monthly:
                        AnalyticsView(selectedMonth: $viewModel.selectedMonth, expenseViewModel: viewModel.expenseViewModel)
                    case .yearly:
                        YearlyAnalyticsView(expenseViewModel: viewModel.expenseViewModel)
                    case .profile:
                        ProfileView(authViewModel: viewModel.authViewModel)
                    case .categories:
                        CategoriesView(expenseViewModel: viewModel.expenseViewModel)
                    }
                }
            }
        }
        .onAppear {
            if viewModel.authViewModel.isAuthenticated {
                viewModel.expenseViewModel.loadData(month: viewModel.selectedMonth)
            }
        }
        .onChange(of: viewModel.authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                viewModel.expenseViewModel.loadData(month: viewModel.selectedMonth)
            }
        }
        .onChange(of: viewModel.selectedMonth) { newMonth in
            if viewModel.authViewModel.isAuthenticated {
                viewModel.expenseViewModel.loadData(month: newMonth)
            }
        }
    }
}

#Preview {
    let authService = AuthService()
    let expenseService = ExpenseService()
    let authViewModel = AuthViewModel(authService: authService)
    let expenseViewModel = ExpenseViewModel(expenseService: expenseService)
    return MainView(authViewModel: authViewModel, expenseViewModel: expenseViewModel)
}
