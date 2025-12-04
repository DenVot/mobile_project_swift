import SwiftUI

struct LoginViewWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var authService: AuthService
    
    func makeUIViewController(context: Context) -> LoginViewController {
        let loginVC = LoginViewController()
        loginVC.authService = authService
        return loginVC
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        uiViewController.authService = authService
    }
}

