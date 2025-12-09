import SwiftUI

struct LoginViewWrapper: UIViewControllerRepresentable {
    @ObservedObject var authViewModel: AuthViewModel
    
    func makeUIViewController(context: Context) -> LoginViewController {
        return LoginViewController(authViewModel: authViewModel)
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
    }
}

