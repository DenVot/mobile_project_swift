import SwiftUI

enum NavigationDestination: Hashable {
    case register
    case main
}

struct ContentView: View {
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var expenseViewModel: ExpenseViewModel
    @State private var navigationPath = NavigationPath()
    
    init(authService: AuthServiceProtocol, expenseService: ExpenseServiceProtocol) {
        _authViewModel = StateObject(wrappedValue: AuthViewModel(authService: authService))
        _expenseViewModel = StateObject(wrappedValue: ExpenseViewModel(expenseService: expenseService))
    }
    
    var body: some View {
        if authViewModel.isAuthenticated {
            MainView(authViewModel: authViewModel, expenseViewModel: expenseViewModel)
        } else {
            NavigationStack(path: $navigationPath) {
                LoginViewWrapper(authViewModel: authViewModel)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        switch destination {
                        case .register:
                            RegisterViewWrapper(authViewModel: authViewModel)
                        case .main:
                            EmptyView()
                        }
                    }
            }
        }
    }
}

#Preview {
    let authService = AuthService()
    let expenseService = ExpenseService()
    return ContentView(authService: authService, expenseService: expenseService)
}
