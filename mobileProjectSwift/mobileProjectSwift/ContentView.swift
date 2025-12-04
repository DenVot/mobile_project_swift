import SwiftUI

enum NavigationDestination: Hashable {
    case register
    case main
}

struct ContentView: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            LoginView(navigationPath: $navigationPath)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .register:
                        RegisterView(navigationPath: $navigationPath)
                    case .main:
                        MainView()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
