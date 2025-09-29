import SwiftUI

struct LoginView: View {
    @State private var login: String = ""
    @State private var password: String = ""
    
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        NavigationStack {
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
                
                Button("Войти") {
                    authVM.login(username: login, password: password)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                NavigationLink("Регистрация", destination: RegisterView(authVM: authVM))
                    .padding(.top, 10)
                
                NavigationLink(destination: /*НЕ ЗАБЫТЬ СЮДА ВСТАВИТЬ МЭИН ВЬЮ!!!!*/, isActive: $authVM.isAuthenticated) {
                    EmptyView()
                }
            }
        }
    }
}
