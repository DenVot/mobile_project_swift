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
                LoginView(navigationPath: $navigationPath)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        switch destination {
                        case .register:
                            RegisterView(navigationPath: $navigationPath)
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
