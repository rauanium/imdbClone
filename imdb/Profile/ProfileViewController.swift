//
//  ProfileViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import UIKit

class ProfileViewController: UIViewController {
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 10
        profileImageView.image = UIImage(named: "elon")
        return profileImageView
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
        view.backgroundColor = .orange
        setupViews()
    }
    
    private func setupViews(){
        
        
        view.backgroundColor = .white
        self.navigationItem.title = "Profile"
        [profileImageView, loginButton].forEach {
            view.addSubview($0)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(200)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
    }
    
    @objc
    private func didTapLoginButton(){
        print("tapped")
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true)
//        navigationController?.pushViewController(loginViewController, animated: true)
    }
}
