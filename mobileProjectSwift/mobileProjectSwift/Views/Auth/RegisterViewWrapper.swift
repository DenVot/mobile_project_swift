import SwiftUI

struct RegisterViewWrapper: UIViewControllerRepresentable {
    @ObservedObject var authViewModel: AuthViewModel
    
    func makeUIViewController(context: Context) -> RegisterViewController {
        return RegisterViewController(authViewModel: authViewModel)
    }
    
    func updateUIViewController(_ uiViewController: RegisterViewController, context: Context) {
    }
}

