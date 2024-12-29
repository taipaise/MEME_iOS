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
        case memeLogin
        case snsSignUp
        case modelHome
        case artistHome
        case none
    }
    
    struct Input {
        let socialLogin: Observable<SocialProvider>
        let memeLogin: Observable<Void>
    }
    
    struct Output {
        var navigation: Observable<NavigationType>
    }
    
    private var userDTO: IsUserDTO?
    private var navigation = PublishSubject<NavigationType>()
    private var authManager = AuthManager.shared
    private var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        input.socialLogin
            .subscribe { [weak self] provider in
                switch provider {
                case .APPLE:
                    self?.perfromAppleLogin()
                case .KAKAO:
                    self?.performKakaoLogin()
                }
            }
            .disposed(by: disposeBag)
        
        input.memeLogin
            .subscribe { [weak self] _ in
                self?.navigation.onNext(.memeLogin)
            }
            .disposed(by: disposeBag)

        return Output(navigation: navigation.asObservable())
    }
}

// MARK: - 유저 체크, 화면 이동

extension LoginViewModel {
    private func validateUser(checkDTO: CheckDTO) async -> IsUserDTO? {
        let isUser = await authManager.validateUser(
            idToken: checkDTO.idToken,
            socialProvider: checkDTO.provider
        )
        
        switch isUser {
        case .success(let result):
            let userDTO = result.data
            KeyChainManager.save(forKey: .memberId, value: "\(String(userDTO.user_id ?? -1))")
            KeyChainManager.save(forKey: .accessToken, value: userDTO.access_token ??  "")
            KeyChainManager.save(forKey: .refreshToken, value: userDTO.refresh_token ?? "")
            KeyChainManager.save(forKey: .role, value: userDTO.role ?? "")
            return userDTO
        case .failure(let error):
            print(error.localizedDescription)
            return IsUserDTO(
                access_token: nil,
                refresh_token: nil,
                user_status: false,
                user_id: nil,
                role: nil
            )
        }
    }
    
    private func setNavigationType(userInfo: IsUserDTO?) {
        guard let userInfo = userInfo else {
            navigation.onNext(.none)
            return
        }
        
        guard userInfo.user_status == true else {
            navigation.onNext(.snsSignUp)
            return
        }
       
        let role = userInfo.role
        if role == RoleType.ARTIST.rawValue {
            navigation.onNext(.artistHome)
        } else {
            navigation.onNext(.modelHome)
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
        setNavigationType(userInfo: nil)
        print("apple login failed")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityToken = credential.identityToken,
            let idTokenString = String(data: identityToken, encoding: .utf8)
        else { return }
        
        UserDefaultManager.shared.saveProvider(.APPLE)
        UserDefaultManager.shared.saveIdToken(idTokenString)
        let checkDTO = CheckDTO(provider: .APPLE, idToken: idTokenString)
        Task {
            let userInfo = await validateUser(checkDTO: checkDTO)
            setNavigationType(userInfo: userInfo)
        }
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
                let userInfo = await validateUser(checkDTO: checkDTO)
            else {
                
                setNavigationType(userInfo: nil)
                return
            }
            
            setNavigationType(userInfo: userInfo)
        }
    }
    
    private func loginWithKakaoApp() async -> CheckDTO? {
        await withCheckedContinuation { continuationn in
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe { oAuthToken in
                    if let idToken = oAuthToken.idToken {
                        continuationn.resume(returning: CheckDTO(provider: .KAKAO, idToken: idToken))
                        UserDefaultManager.shared.saveProvider(.KAKAO)
                        UserDefaultManager.shared.saveIdToken(idToken)
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
                        UserDefaultManager.shared.saveProvider(.KAKAO)
                        UserDefaultManager.shared.saveIdToken(idToken)
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
