import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let user = authViewModel.currentUser {
                Text(user.name)
                    .font(.title)
                    .bold()
            }
            
            Button {
                authViewModel.logout()
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
    }
}

#Preview {
    let authService = AuthService()
    let authViewModel = AuthViewModel(authService: authService)
    return NavigationStack {
        ProfileView(authViewModel: authViewModel)
    }
}

