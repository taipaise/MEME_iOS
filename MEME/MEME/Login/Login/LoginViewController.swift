//
//  LoginViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func kakaoLoginButtonTapped(_ sender: Any) {
        //임시 이동 코드
        let nextVC = TermsAgreementViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        kakaoLogin()
    }
    
    
    @IBAction private func appleLoginButtonTapped(_ sender: Any) {
        appleLogin()
    }
    
}

// MARK: - login 로직
extension LoginViewController {
    
    private func kakaoLogin() {
        
    }
    
    private func appleLogin() {
        
    }
}
