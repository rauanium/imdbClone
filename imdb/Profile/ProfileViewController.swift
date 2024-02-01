//
//  ProfileViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import UIKit
import Lottie
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {
    
    private lazy var profileAnimationView: LottieAnimationView = {
        let profileAnimationView = LottieAnimationView(name: "profileAnimation")
        profileAnimationView.contentMode = .scaleAspectFit
        profileAnimationView.animationSpeed = 1.25
        profileAnimationView.backgroundBehavior = .pauseAndRestore
        return profileAnimationView
    }()
    
    private lazy var userLabel: UILabel = {
        let userLabel = UILabel()
        userLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        userLabel.textAlignment = .center
        return userLabel
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .gray
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return loginButton
    }()
    
    
    
    //MARK: - ui elements if sessionID is created
    var networkManager = NetworkManager.shared
    var emailText: String?
    var passwordText: String?
    var passwordStatus: Bool = true
    var keychainSessionID = KeychainWrapper.standard.string(forKey: "sessionID")
    var keychainUserName = KeychainWrapper.standard.string(forKey: "username")
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
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    private lazy var showHidePasswordButton: UIButton = {
        let showHidePasswordButton = UIButton()
        showHidePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showHidePasswordButton.tintColor = .black
        showHidePasswordButton.addTarget(self, action: #selector(didTogglePassword), for: .touchUpInside)
        return showHidePasswordButton
    }()
    
    private lazy var statusText: UILabel = {
        let statusText = UILabel()
        statusText.text = ""
        return statusText
    }()
    
    private lazy var submitButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .gray
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        return loginButton
    }()

    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if keychainSessionID == nil {
            setupUI()
        } else {
            setupViews()
            userLabel.text = keychainUserName ?? "user not defined"
            
        }
    }
    
    //MARK: - setupviews if user dont have session id
    private func setupViews(){
        
        profileAnimationView.play(fromProgress: profileAnimationView.currentProgress, toProgress: 1, loopMode: .loop)
        view.backgroundColor = .white
        self.navigationItem.title = "Profile"
        [profileAnimationView, userLabel, loginButton].forEach {
            view.addSubview($0)
        }
        profileAnimationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        userLabel.snp.makeConstraints { make in
            make.top.equalTo(profileAnimationView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview().inset(16)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
    }
    
    @objc
    private func didTapLoginButton(){
//        print("tapped")
        let loginViewController = LoginViewController()
//        present(loginViewController, animated: true)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    //MARK: - ui elements if user has sessionID
    private func setupUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "Log In"
        [emailTextField, passwordTextField, statusText, submitButton].forEach {
            view.addSubview($0)
        }
        passwordTextField.addSubview(showHidePasswordButton)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.left.right.equalTo(emailTextField)
        }
        showHidePasswordButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        
        statusText.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.right.equalTo(emailTextField)
            make.height.greaterThanOrEqualTo(20)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(statusText.snp.bottom).offset(16)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
    }
    
    @objc
    private func didTogglePassword(){
        passwordStatus = !passwordStatus
        if passwordStatus {
            passwordTextField.isSecureTextEntry = true
            showHidePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
            
        } else {
            passwordTextField.isSecureTextEntry = false
            showHidePasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            
        }
    }
    
    @objc
    private func didTapSubmitButton() {
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
            case .failure:
                print("failed in button Function")
                self?.showAlert(title: "Error", message: "Network connection error")
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
                print("validateWithLogin Function")
                self?.showAlert(title: "Error", message: "Could not find login or password")
            }
        })
    }
    
    private func createSession(with requestBody: [String: Any]) {
        networkManager.createSession(requestBody: requestBody) { [weak self] result in
            print("create session result: \(result)")
            switch result {
            case .success(let sessionID):
                print("My sessionId is \(sessionID)")
                self?.saveSessionID(with: sessionID)
            case .failure:
                print("Failure in create session")
                self?.showAlert(title: "Cant create session", message: "Something went wrong")
            }
        }
    }
//    aida.moldaly
//    Standartny2020
    
    private func saveSessionID(with sessionID: String) {
        print("saveSessionFunction")
        print("this is sessionID: \(sessionID)")
        print("this is emailText: \(emailText!)")
        
        let sessionIDValue = KeychainWrapper.standard.set(sessionID, forKey: "sessionID")
        let usernameValue = KeychainWrapper.standard.set(emailText!, forKey: "username")
        print("usernameValue: \(usernameValue)")
        if sessionIDValue  {
            statusText.text = "Saved successfully"
            statusText.textColor = .green
        } else {
            statusText.text = "Something went wrong"
            statusText.textColor = .red
        }
         
        
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("alert was called")
        }))
    }
    
    
    
    
    
    
    
    
    
    
}
