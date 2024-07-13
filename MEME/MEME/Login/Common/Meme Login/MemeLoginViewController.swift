//
//  MemeLoginViewController.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit
import SnapKit

final class MemeLoginViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .logo
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        
        view.borderStyle = .none
        view.layer.borderColor = UIColor.gray400.cgColor
        view.layer.borderWidth = 1
        view.placeholder = "이메일"
        view.font = .pretendard(to: .medium, size: 14)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .none
        view.layer.borderColor = UIColor.gray400.cgColor
        view.layer.borderWidth = 1
        view.placeholder = "비밀번호"
        view.font = .pretendard(to: .medium, size: 14)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.tintColor = .white
        button.backgroundColor = .mainBold
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var findEmailButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일 찾기", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 12)
        button.setTitleColor(.gray400, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var findPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 12)
        button.setTitleColor(.gray400, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 12)
        button.setTitleColor(.mainBold, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var divideLine1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray400
        return view
    }()
    
    private lazy var divideLine2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray400
        return view
    }()
    
    private lazy var snsLabel: UILabel = {
        let label = UILabel()
        label.text = "SNS 계정으로 로그인하기"
        label.font = .pretendard(to: .regular, size: 12)
        return label
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(.kakaoRound, for: .normal)
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(.appleRound, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        makeConstraints()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        [kakaoLoginButton, appleLoginButton].forEach {
            let height = $0.bounds.height
            $0.layer.cornerRadius = height / 2
            $0.layer.masksToBounds = true
        }
        
        [emailTextField, passwordTextField].forEach {
            $0.addLeftPadding(padding: 11)
        }
    }
}

// MARK: - layout configuration
extension MemeLoginViewController {
    private func addSubViews() {
        view.addSubViews([
            logoImageView,
            emailTextField,
            passwordTextField,
            loginButton,
            findEmailButton,
            findPasswordButton,
            signUpButton,
            divideLine1,
            divideLine2,
            snsLabel,
            kakaoLoginButton,
            appleLoginButton
        ])
    }
    private func makeConstraints() {
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(68)
            $0.height.equalTo(43)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(38)
        }
        
        emailTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(logoImageView.snp.bottom).offset(50)
            $0.height.equalTo(49)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
            $0.height.equalTo(49)
        }
        
        loginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.height.equalTo(49)
        }
        
        findEmailButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(40)
        }
        
        divideLine1.snp.makeConstraints {
            $0.trailing.equalTo(findEmailButton.snp.leading).offset(-8)
            $0.centerY.equalTo(findEmailButton)
            $0.width.equalTo(1)
            $0.height.equalTo(11)
        }
        
        findPasswordButton.snp.makeConstraints {
            $0.trailing.equalTo(divideLine1.snp.leading).offset(-8)
            $0.centerY.equalTo(findEmailButton)
        }
        
        divideLine2.snp.makeConstraints {
            $0.leading.equalTo(findEmailButton.snp.trailing).offset(8)
            $0.centerY.equalTo(findEmailButton)
            $0.width.equalTo(1)
            $0.height.equalTo(11)
        }
        
        signUpButton.snp.makeConstraints {
            $0.leading.equalTo(divideLine2.snp.trailing).offset(8)
            $0.centerY.equalTo(findEmailButton)
        }
        
        snsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signUpButton.snp.bottom).offset(44)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-34)
            $0.top.equalTo(snsLabel.snp.bottom).offset(38)
            $0.size.equalTo(46)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(34)
            $0.top.equalTo(snsLabel.snp.bottom).offset(38)
            $0.size.equalTo(46)
        }
        
    }
}
