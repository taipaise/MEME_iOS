//
//  SetProfileViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SetProfileImageViewModel: NSObject, ViewModel {
    enum NavigationType {
        case fail
        case success
        case none
    }
    
    struct Input {
        let skipTap: Observable<Void>
        let nextTap: Observable<Void>
    }
    
    struct Output {
        let profileImage: Observable<UIImage>
        let nextButtonState: Observable<Bool>
        var navigation: Observable<NavigationType>
    }
    
    private(set) var profileInfo: SignUpProfileInfo
    private let profileImage = BehaviorRelay<UIImage>(value: .defaultProfile)
    private let skipState = BehaviorRelay<Bool>(value: false)
    private var navigation = PublishSubject<NavigationType>()
    private let imagePickerManager = ImagePickerManager()
    private let phPickerManager = PHPickerManager()
    private var disposeBag = DisposeBag()
    private let authManager = AuthManager.shared
    
    init(profileInfo: SignUpProfileInfo) {
        self.profileInfo = profileInfo
        super.init()
        bindPicker()
    }
    
    func transform(_ input: Input) -> Output {
        input.skipTap
            .subscribe { [weak self] _ in
                self?.toggleSkip()
            }
            .disposed(by: disposeBag)
        
        input.nextTap
            .subscribe { [weak self] _ in
                print(self?.profileInfo)
                // TODO: - 서버 열리면 주석 해제
//                Task {
//                    let result = await self?.modelSignUp()
//                    if
//                        let result,
//                        result
//                    {
//                        self?.navigation.onNext(.success)
//                    } else {
//                        self?.navigation.onNext(.fail)
//                    }
//                }
                self?.navigation.onNext(.success)
            }
            .disposed(by: disposeBag)
        
        return Output(
            profileImage: profileImage.asObservable(),
            nextButtonState: Observable.combineLatest(skipState, profileImage)
                .map { return $0 || $1 != .defaultProfile },
            navigation: navigation.asObservable()
            )
    }
}

// MARK: - binding
extension SetProfileImageViewModel {
    private func bindPicker() {
        imagePickerManager.selectedImage
            .subscribe { [weak self] image in
                self?.profileImage.accept(image ?? UIImage.defaultProfile)
                // TODO: - 이미지 업로드 처리
            }
            .disposed(by: disposeBag)
        
        phPickerManager.selectedImage
            .subscribe { [weak self] image in
                self?.profileImage.accept(image ?? UIImage.defaultProfile)
                // TODO: - 이미지 업로드 처리
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - action
extension SetProfileImageViewModel {
    private func toggleSkip() {
        var state = skipState.value
        skipState.accept(!state)
    }
    
    func presentImagePicker(_ viewController: UIViewController) {
        imagePickerManager.present(from: viewController)
    }
    
    func presentPHPicker(_ viewController: UIViewController) {
        phPickerManager.present(from: viewController)
    }
    
    private func modelSignUp() async -> Bool {
        let result = await authManager.modelSignUp(profileInfo: profileInfo)
        
        switch result {
        case .success(let result):
            let userData = result.data
            let userId = userData.userId
            let accessToken = userData.accessToken
            let refreshToken = userData.refreshToken
            KeyChainManager.save(forKey: .memberId, value: "\(userId)")
            KeyChainManager.save(forKey: .accessToken, value: accessToken)
            KeyChainManager.save(forKey: .refreshToken, value: refreshToken)
            KeyChainManager.save(forKey: .nickName, value: profileInfo.nickname)
            KeyChainManager.save(forKey: .role, value: RoleType.MODEL.rawValue)
            return true
        case .failure(let error):
            print(error.localizedDescription)
            return false
        }
    }
}

