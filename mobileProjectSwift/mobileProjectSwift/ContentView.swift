import SwiftUI

enum NavigationDestination: Hashable {
    case register
    case main
}

struct ContentView: View {
    @EnvironmentObject private var authService: AuthService
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        if authService.isAuthenticated {
            MainView()
        } else {
            NavigationStack(path: $navigationPath) {
                LoginViewWrapper()
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        switch destination {
                        case .register:
                            RegisterViewWrapper()
                        case .main:
                            EmptyView()
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
