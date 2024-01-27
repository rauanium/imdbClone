//
//  ProfileViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import UIKit
import Lottie

class ProfileViewController: UIViewController {
    
    private lazy var profileAnimationView: LottieAnimationView = {
        let profileAnimationView = LottieAnimationView(name: "profile")
        profileAnimationView.contentMode = .scaleAspectFit
        profileAnimationView.animationSpeed = 1.25
        profileAnimationView.backgroundBehavior = .pauseAndRestore
        return profileAnimationView
    }()
    
//    private lazy var profileImageView: UIImageView = {
//        let profileImageView = UIImageView()
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.layer.cornerRadius = 10
//        profileImageView.image = UIImage(named: "elon")
//        return profileImageView
//    }()
    
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
        
        profileAnimationView.play(fromProgress: profileAnimationView.currentProgress, toProgress: 1, loopMode: .loop)
        view.backgroundColor = .white
        self.navigationItem.title = "Profile"
        [profileAnimationView, loginButton].forEach {
            view.addSubview($0)
        }
        profileAnimationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(200)
            
//            make.left.equalToSuperview().offset(16)
//            make.right.equalToSuperview().offset(-16)
//            make.height.equalTo(200)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(profileAnimationView.snp.bottom).offset(40)
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
