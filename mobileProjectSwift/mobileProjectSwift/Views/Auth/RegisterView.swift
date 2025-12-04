import SwiftUI

struct RegisterView: View {
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Binding var navigationPath: NavigationPath
    
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Регистрация")
                .font(.largeTitle)
                .bold()
            
            TextField("Логин", text: $login)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Пароль", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Повторите пароль", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button {
                authService.register(username: login, password: password, confirmPassword: confirmPassword)
            } label: {
                Text("Зарегистрироваться")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AuthService())
    }
}
