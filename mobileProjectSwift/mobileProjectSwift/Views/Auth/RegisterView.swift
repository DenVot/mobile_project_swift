import SwiftUI

struct RegisterView: View {
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @ObservedObject var authVM: AuthViewModel
    
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
            
            Button("Войти") {
                authVM.register(username: login, password: password, confirmPassword: confirmPassword)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            
            NavigationLink(destination: /*НЕ ЗАБЫТЬ СЮДА ВСТАВИТЬ МЭИН ВЬЮ!!!!*/, isActive: $authVM.isAuthenticated) {
                EmptyView()
            }
        }
    }
}
