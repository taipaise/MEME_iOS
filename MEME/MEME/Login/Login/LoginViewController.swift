//
//  LoginViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import KakaoSDKUser
import AuthenticationServices

final class LoginViewController: UIViewController {
    let userDefaultManager = UserDefaultManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaultManager.removeId()
        userDefaultManager.removeProvider()
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
        userDefaultManager.saveProvider(SocialProvider.KAKAO.rawValue)
    }
    
    private func appleLogin() {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
          authorizationController.delegate = self
          authorizationController.presentationContextProvider = self
          authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        userDefaultManager.saveProvider(SocialProvider.APPLE.rawValue)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
