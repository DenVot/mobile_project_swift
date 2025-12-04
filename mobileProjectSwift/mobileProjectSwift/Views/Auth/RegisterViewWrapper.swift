import SwiftUI

struct RegisterViewWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var authService: AuthService
    
    func makeUIViewController(context: Context) -> RegisterViewController {
        let registerVC = RegisterViewController()
        registerVC.authService = authService
        return registerVC
    }
    
    func updateUIViewController(_ uiViewController: RegisterViewController, context: Context) {
        uiViewController.authService = authService
    }
}

