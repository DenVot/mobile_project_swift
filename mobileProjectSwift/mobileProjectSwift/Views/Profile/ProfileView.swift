import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 100)
            
            if let user = authService.currentUser {
                Text(user.name)
                    .font(.title)
                    .bold()
            }
            
            Button {
                authService.logout()
            } label: {
                Text("Выйти")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(authService.currentUser?.name ?? "Профиль")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthService())
    }
}

