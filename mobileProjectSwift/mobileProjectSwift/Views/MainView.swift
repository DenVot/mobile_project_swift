import SwiftUI

enum MainTab: CaseIterable {
    case monthly
    case yearly
    case profile
    case categories
    
    func title(authService: AuthService) -> String {
        switch self {
        case .monthly:
            return "Месяц"
        case .yearly:
            return "Аналитика за год"
        case .profile:
            return authService.currentUser?.name ?? "Профиль"
        case .categories:
            return "Категории"
        }
    }
}

enum MainNavigationDestination: Hashable {
    case categories
    case profile
}

struct MainView: View {
    @EnvironmentObject private var authService: AuthService
    @StateObject private var expenseService = ExpenseService()
    @State private var selectedTab: MainTab = .monthly
    @State private var selectedMonth = Date()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(MainTab.allCases, id: \.self) { tab in
                        Button {
                            selectedTab = tab
                            if tab == .categories {
                                navigationPath.append(MainNavigationDestination.categories)
                            } else if tab == .profile {
                                navigationPath.append(MainNavigationDestination.profile)
                            }
                        } label: {
                            Text(tab.title(authService: authService))
                                .font(.system(size: 16))
                                .foregroundColor(selectedTab == tab ? .blue : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear)
                        }
                    }
                }
                .background(Color.gray.opacity(0.1))
                
                Group {
                    switch selectedTab {
                    case .monthly:
                        AnalyticsView(selectedMonth: $selectedMonth, expenseService: expenseService)
                    case .yearly:
                        YearlyAnalyticsView(expenseService: expenseService)
                    case .profile:
                        ProfileView()
                    case .categories:
                        CategoriesView(expenseService: expenseService)
                    }
                }
            }
            .navigationDestination(for: MainNavigationDestination.self) { destination in
                switch destination {
                case .categories:
                    CategoriesView(expenseService: expenseService)
                case .profile:
                    ProfileView()
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthService())
}
