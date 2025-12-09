import UIKit
import Combine

class LoginViewController: UIViewController {
    private var loginTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginButton: UIButton!
    private var registerButton: UIButton!
    private var titleLabel: UILabel!
    
    private let authViewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        titleLabel = UILabel()
        titleLabel.text = "Вход"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        loginTextField = UITextField()
        loginTextField.placeholder = "Логин"
        loginTextField.borderStyle = .roundedRect
        loginTextField.autocapitalizationType = .none
        loginTextField.autocorrectionType = .no
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(loginTextField)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(passwordTextField)
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(loginButton)
        
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Регистрация", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            loginTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            loginTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc private func loginButtonTapped() {
        guard let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        
        authViewModel.login(username: login, password: password)
    }
    
    @objc private func registerButtonTapped() {
        let registerVC = RegisterViewController(authViewModel: authViewModel)
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

