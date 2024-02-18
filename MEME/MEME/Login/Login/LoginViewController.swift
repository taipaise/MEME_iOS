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
        print(KeyChainManager.read(forkey: .accessToken))
        print(KeyChainManager.read(forkey: .refreshToken))
        super.viewDidLoad()
    }
    
    @IBAction private func kakaoLoginButtonTapped(_ sender: Any) {
        //임시 이동 코드
        kakaoLogin()
    }
    
    
    @IBAction private func appleLoginButtonTapped(_ sender: Any) {
        appleLogin()
    }
}

// MARK: - login 로직
extension LoginViewController {
    
    private func kakaoLogin() {
        if
            let provider = userDefaultManager.getProvider(),
            KeyChainManager.read(forkey: .role) != "",
            KeyChainManager.read(forkey: .accessToken) != "",
            provider == SocialProvider.KAKAO.rawValue
        {
            if KeyChainManager.read(forkey: .role) == "ARTIST" {
                let nextVC = ArtistTabBarController()
                navigationController?.pushViewController(nextVC, animated: true)
            } else {
                let nextVC = ModelTabBarController()
                navigationController?.pushViewController(nextVC, animated: true)
            }
            
            return
        }
        
        userDefaultManager.saveProvider(SocialProvider.KAKAO.rawValue)
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {[weak self](oauthToken, error) in
                if let error = error {
                    print("에러 발생",error)
                } else {
                    self?.userDefaultManager.saveIdToken(oauthToken!.idToken!)
                    let nextVC = TermsAgreementViewController()
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {[weak self](oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    self?.userDefaultManager.saveIdToken(oauthToken!.idToken!)
                    let nextVC = TermsAgreementViewController()
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                    _ = oauthToken
                }
            }
        }
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
        //회원 가입이 이미 되어있는 경우 야매 처리 코드
        if
            let provider = userDefaultManager.getProvider(),
            let role = KeyChainManager.read(forkey: .role),
            let key = KeyChainManager.read(forkey: .accessToken),
            provider == SocialProvider.KAKAO.rawValue
        {
            if role == "ARTIST" {
                let nextVC = SetBusinessInfoViewController()
                navigationController?.pushViewController(nextVC, animated: true)
            } else {
                let nextVC = ModelTabBarController()
                navigationController?.pushViewController(nextVC, animated: true)
            }
            
            return
        }
        
        userDefaultManager.saveProvider(SocialProvider.APPLE.rawValue)
        let authManager = AuthManager.shared
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityToken = credential.identityToken,
            let tokenString = String(data: identityToken, encoding: .utf8)
        else { return }
        
        userDefaultManager.saveIdToken(tokenString)
        
        
        let nextVC = TermsAgreementViewController()
        navigationController?.pushViewController(nextVC, animated: true)
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
