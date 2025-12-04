import SwiftUI

struct LoginView: View {
    @State private var login: String = ""
    @State private var password: String = ""
    @Binding var navigationPath: NavigationPath
    
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Вход")
                .font(.largeTitle)
                .bold()
            
            TextField("Логин", text: $login)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Пароль", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button {
                authService.login(username: login, password: password)
            } label: {
                Text("Войти")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button("Регистрация") {
                navigationPath.append(NavigationDestination.register)
            }
            .foregroundColor(.blue)
            .padding(.top, 10)
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AuthService())
    }
}
