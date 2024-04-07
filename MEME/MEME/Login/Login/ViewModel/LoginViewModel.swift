//
//  LoginViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa
import KakaoSDKUser
import AuthenticationServices

final class LoginViewModel: NSObject, ViewModel {
    
    enum NavigationType {
        case signUp
        case modelHome
        case artistHome
    }
    
    struct Input {
        let kakaoLoginTap: PublishRelay<Void>
        let appleLoginTap: PublishRelay<Void>
    }
    
    struct Output {
        var navigation: Observable<NavigationType>
    }
    
    private var navigation = PublishSubject<NavigationType>()
    private var authManager = AuthManager.shared
    var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.appleLoginTap
            .subscribe { [weak self] _ in
                self?.perfromAppleLogin()
            }
            .disposed(by: disposeBag)
        
        input.kakaoLoginTap
            .subscribe { [weak self] _ in
                self?.performKakaoLogin()
            }
            .disposed(by: disposeBag)
        
        return Output(navigation: navigation.asObservable())
    }
}

// MARK: - check is user
extension LoginViewModel {
    private func checkIsUser(socialProvider: SocialProvider, idToken: String) async {
        let isUser = await authManager.checkIsUser(idToken: idToken, socialProvider: socialProvider)
        switch isUser {
        case .success(let result):
            if result.message == "사용자 정보가 확인되었습니다." {
                switch socialProvider {
                case .APPLE:
                    // TODO: - coordinator를 이용한 화면 전환 로직 추가
                    break
                case .KAKAO:
                    // TODO: - coordinator를 이용한 화면 전환 로직 추가
                    break
                }
            } else {
                let userDTO = result.data
                KeyChainManager.save(forKey: .memberId, value: "\(userDTO.userId)")
                KeyChainManager.save(forKey: .role, value: "\(userDTO.role)")
                // TODO: - coordinator를 이용한 화면 전환 로직 추가
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

// MARK: - Apple Login
extension LoginViewModel: ASAuthorizationControllerDelegate {
    private func perfromAppleLogin() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
          authorizationController.delegate = self
          authorizationController.presentationContextProvider = self
          authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("apple login failed")
    }
    
    private func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) async {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityToken = credential.identityToken,
            let idTokenString = String(data: identityToken, encoding: .utf8)
        else { return }
        
        await checkIsUser(socialProvider: .APPLE, idToken: idTokenString)
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            fatalError("No window found")
        }
        
        return window
    }
}

// MARK: - Kakao Login
extension LoginViewModel {
    private func performKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoApp()
        } else {
            loginWithKakaoAccount()
        }
    }
    
    private func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
            guard
                error == nil,
                let idToken = oauthToken?.idToken
            else {
                print("kakao login error")
                return
            }
            
            self?.checkIsUser(socialProvider: .KAKAO, idToken: idToken)
        }
    }
    
    private func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error  in
            guard
                error == nil,
                let idToken = oauthToken?.idToken
            else {
                print("kakao login error")
                return
            }
            
            self?.checkIsUser(socialProvider: .KAKAO, idToken: idToken)
        }
    }
}
