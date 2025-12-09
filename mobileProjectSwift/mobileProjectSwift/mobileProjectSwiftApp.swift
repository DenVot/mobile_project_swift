import SwiftUI

@main
struct mobileProjectSwiftApp: App {
    private let authService: AuthServiceProtocol = AuthService()
    private let expenseService: ExpenseServiceProtocol = ExpenseService()
    
    var body: some Scene {
        WindowGroup {
            ContentView(authService: authService, expenseService: expenseService)
        }
    }
}
