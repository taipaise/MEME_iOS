//
//  SetProfileViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit
import RxSwift
import RxCocoa

enum NickNameStatus {
    case lengthLimit
    case valid
    case duplicate
    
    var message: String {
        switch self {
        case .lengthLimit:
            "닉네임은 최대 15자 작성 가능합니다."
        case .valid:
            "사용 가능한 닉네임입니다."
        case .duplicate:
            "이미 사용중인 닉네임입니다."
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .lengthLimit, .duplicate:
            return .red
        case .valid:
            return .blue
        }
    }
}

final class SetProfileViewModel: NSObject, ViewModel {
    struct Input {
        let name: Observable<String>
        let nickname: Observable<String>
        let verifyTap: Observable<Void>
    }
    
    struct Output {
        let profileImage: Observable<UIImage>
        let nickNameStatus: Observable<NickNameStatus?>
        let nextButtonState: Observable<Bool>
    }
    
    private(set) var roleType: RoleType
    private let profileImage = BehaviorRelay<UIImage>(value: .defaultProfile)
    private let isNickNameVerified = BehaviorRelay<Bool>(value: false)
    private let nickNameStatus = BehaviorRelay<NickNameStatus?>(value: nil)
    private var profileInfo: ProfileInfo
    private let imagePickerManager = ImagePickerManager()
    private let phPickerManager = PHPickerManager()
    private var disposeBag = DisposeBag()
    
    init(roleType: RoleType) {
        self.roleType = roleType
        profileInfo = ProfileInfo(profileImg: "", username: "", nickname: "")
        super.init()
        bindPicker()
    }
    
    func transform(_ input: Input) -> Output {
        input.name.subscribe { [weak self] name in
            self?.setName(name)
        }
        .disposed(by: disposeBag)
        
        input.nickname.subscribe { [weak self] nickname in
            self?.setNickname(nickname)
        }
        .disposed(by: disposeBag)
        
        input.verifyTap.subscribe { [weak self] _ in
            self?.verifyNickName()
        }
        .disposed(by: disposeBag)
        
        let nameAndNicknameFilled = Observable.combineLatest(input.name, input.nickname)
            .map { name, nickname in
                !name.isEmpty && !nickname.isEmpty
            }
        
        return Output(
            profileImage: profileImage.asObservable(),
            nickNameStatus: nickNameStatus.asObservable(),
            nextButtonState: Observable.combineLatest(nameAndNicknameFilled, isNickNameVerified)
                .map { nameAndNicknameFilled, isNickNameVerified in
                    return nameAndNicknameFilled && isNickNameVerified
                }
            )
    }
}

// MARK: - binding
extension SetProfileViewModel {
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
extension SetProfileViewModel {
    private func setName(_ name: String) {
        profileInfo.username = name
    }
    
    private func setNickname(_ nickname: String) {
        guard nickname != profileInfo.nickname else { return }
        
        profileInfo.nickname = nickname
        isNickNameVerified.accept(false)
        if nickname.count > 15 {
            nickNameStatus.accept(.lengthLimit)
        } else {
            nickNameStatus.accept(.none)
        }
    }
    
    private func verifyNickName() {
        let nickname = profileInfo.nickname
        if nickname.count > 15 { return }
        
        // TODO: - 닉네임 중복 여부 체크
        isNickNameVerified.accept(true)
        nickNameStatus.accept(.valid)
    }
    
    func presentImagePicker(_ viewController: UIViewController) {
        imagePickerManager.present(from: viewController)
    }
    
    func presentPHPicker(_ viewController: UIViewController) {
        phPickerManager.present(from: viewController)
    }
    
}

