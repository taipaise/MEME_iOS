//
//  LoginViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import KakaoSDKUser

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
    
    @IBAction func testButtonTapped(_ sender: Any) {
        let manager = ReservationManager.shared
        
        manager.postReservation(
            modelId: 1,
            portfolioId: 1,
            date: "2024-01-01",
            time: ._06_30,
            dayOfWeek: .SAT,
            location: "강남구 어디어디"
        ) { result in
                print(result)
            }
    }
    
}

// MARK: - login 로직
extension LoginViewController {
    
    private func kakaoLogin() {
        
    }
    
    private func appleLogin() {
        print("sss")
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    print(oauthToken?.idToken)
                    
                    AuthManager.shared.a { result in
                        switch result {
                        case .success(let response):
                            print("a")
                        case .failure(let response):
                            print("b")
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                }
            }
        }
    }
}
