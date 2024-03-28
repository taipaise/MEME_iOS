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
    private let userDefaultManager = UserDefaultManager.shared
    private let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func kakaoLoginButtonTapped(_ sender: Any) {
        kakaoLogin()
    }
    
    
    @IBAction private func appleLoginButtonTapped(_ sender: Any) {
        appleLogin()
    }
}

// MARK: - login 로직
extension LoginViewController {

    private func login(idToken: String, provider: SocialProvider) {
        userDefaultManager.saveProvider(provider.rawValue)
        userDefaultManager.saveIdToken(idToken)
        
        authManager.login(
            idToken: idToken,
            socialProvider: .KAKAO
        ) { loginResult in
            var baseVC: UIViewController
            
            switch loginResult {
            case .success(let loginDTO):
                baseVC = ArtistTabBarController()
            case .failure(let error):
                baseVC = TermsAgreementViewController()
            }
        }
    }
    
    private func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self](oauthToken, error) in
                guard
                    error == nil,
                    let self = self,
                    let idToken = oauthToken?.idToken
                else {
                    print("카카오톡 로그인 에러 발생",error)
                    return
                }
                
                
                }
        } else {
            UserApi.shared.loginWithKakaoAccount {[weak self](oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    self?.userDefaultManager.saveIdToken(oauthToken!.idToken!)
                    let nextVC = TermsAgreementViewController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
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
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
            } else {
                let nextVC = ModelTabBarController()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
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
