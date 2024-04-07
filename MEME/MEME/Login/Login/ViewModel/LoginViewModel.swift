//
//  LoginViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxKakaoSDKUser
import KakaoSDKUser
import AuthenticationServices

final class LoginViewModel: NSObject, ViewModel {
    struct CheckDTO {
        let provider: SocialProvider
        let idToken: String
    }
    
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
    
    private var userDTO: IsUserDTO?
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

// MARK: - 유저 체크, 화면 이동
extension LoginViewModel {
    private func checkIsUser(checkDTO: CheckDTO) async -> IsUserDTO? {
        let isUser = await authManager.checkIsUser(idToken: checkDTO.idToken, socialProvider: checkDTO.provider)
        
        switch isUser {
        case .success(let result):
            let userDTO = result.data
            return userDTO
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func navigate(userInfo: IsUserDTO?) {
        guard let userInfo = userInfo else {
            navigateToSignUp()
            return
        }
        
        navigateToHome()
    }
    
    private func navigateToSignUp() {
        
    }
    
    private func navigateToHome() {
        
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
        
        let checkDTO = CheckDTO(provider: .APPLE, idToken: idTokenString)
        let userInfo = await checkIsUser(checkDTO: checkDTO)
        navigate(userInfo: userInfo)
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
        Task {
            var checkDTO: CheckDTO?
            if UserApi.isKakaoTalkLoginAvailable() {
                await checkDTO = loginWithKakaoApp()
            } else {
                await checkDTO = loginWithKakaoAccount()
            }
            
            guard
                let checkDTO = checkDTO,
                let userInfo = await checkIsUser(checkDTO: checkDTO)
            else {
                navigate(userInfo: nil)
                return
            }
            navigate(userInfo: userInfo)
        }
    }
    
    private func loginWithKakaoApp() async -> CheckDTO? {
        await withCheckedContinuation { continuationn in
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe { oAuthToken in
                    if let idToken = oAuthToken.idToken {
                        continuationn.resume(returning: CheckDTO(provider: .KAKAO, idToken: idToken))
                    } else {
                        continuationn.resume(returning: nil)
                    }
                } onError: { error in
                    continuationn.resume(returning: nil)
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func loginWithKakaoAccount() async -> CheckDTO?  {
        await withCheckedContinuation { continuationn in
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe { oAuthToken in
                    if let idToken = oAuthToken.idToken {
                        continuationn.resume(returning: CheckDTO(provider: .KAKAO, idToken: idToken))
                    } else {
                        continuationn.resume(returning: nil)
                    }
                } onError: { error in
                    continuationn.resume(returning: nil)
                }
                .disposed(by: disposeBag)
        }
    }
}
