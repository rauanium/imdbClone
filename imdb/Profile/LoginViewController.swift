//
//  LoginViewController.swift
//  imdb
//
//  Created by rauan on 1/26/24.
//

import UIKit

class LoginViewController: UIViewController {
    var networkManager = NetworkManager.shared
    var emailText: String?
    var passwordText: String?
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Emter email"
        emailTextField.borderStyle = .roundedRect
        return emailTextField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Emter password"
        passwordTextField.borderStyle = .roundedRect
        return passwordTextField
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .gray
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return loginButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        self.navigationItem.title = "Log In"
        [emailTextField, passwordTextField, loginButton].forEach {
            view.addSubview($0)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.left.right.equalTo(emailTextField)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
    }
    
    @objc
    private func didTapLoginButton() {
        print("login button pressed")
        emailText = emailTextField.text
        passwordText = passwordTextField.text
        
        guard let emailText, let passwordText else { return }
        
        networkManager.getRequestToken { [weak self] result in
            switch result {
            case .success(let dataModel):
                if dataModel.success {
                    let requestData: ValidateAuthenticationModel = .init(username: emailText, password: passwordText, requestToken: dataModel.requestToken)
                    self?.validateWithLogin(with: requestData)
                    
                }
            case .failure: break
            }
        }
    }
    
    private func validateWithLogin(with data: ValidateAuthenticationModel) {
        
        networkManager.validateWithLogin(requestBody: data.toDictionary(), completion: { [weak self] result in
            switch result {
            case.success(let dataModel):
                if dataModel.success {
                    print("my data model\(dataModel)")
                    if dataModel.success {
                        let requestData = ["request_token": dataModel.requestToken]
                        self?.createSession(with: requestData)
                    }
                }
            case .failure:
                break
            }
        }
        )
    }
    
    private func createSession(with requestBody: [String: Any]) {
        networkManager.createSession(requestBody: requestBody) { [weak self] result in
            switch result {
            case .success(let sessionID):
                print("My sessionId is \(sessionID)")
            case .failure:
                break
            }
        }
    }
//    aida.moldaly
//    Standartny2020
    
    
    
    
}
