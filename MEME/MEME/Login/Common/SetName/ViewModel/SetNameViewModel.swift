//
//  SetNameViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/20/24.
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

final class SetNameViewModel: ViewModel {
    struct Input {
        let name: Observable<String>
        let nickname: Observable<String>
        let verifyTap: Observable<Void>
    }
    
    struct Output {
        let nickNameStatus: Observable<NickNameStatus?>
        let nextButtonState: Observable<Bool>
    }
    
    private let isNickNameVerified = BehaviorRelay<Bool>(value: false)
    private let nickNameStatus = BehaviorRelay<NickNameStatus?>(value: nil)
    private(set) var profileInfo: SignUpProfileInfo
    private var disposeBag = DisposeBag()
    
    // TODO: - 추후 바뀔 api에 따라 profile info도 수정될 수 있음
    init(profileInfo: SignUpProfileInfo) {
        self.profileInfo = profileInfo
    }
    
    func transform(_ input: Input) -> Output {
        input.name.subscribe { [weak self] in
            self?.setName($0)
        }
        .disposed(by: disposeBag)
        
        input.nickname.subscribe { [weak self] in
            self?.setNickname($0)
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
        
        let buttonState = Observable.combineLatest(nameAndNicknameFilled, isNickNameVerified)
            .map { nameAndNicknameFilled, isNickNameVerified in
                return nameAndNicknameFilled && isNickNameVerified
            }
        
        return Output(
            nickNameStatus: nickNameStatus.asObservable(),
            nextButtonState: buttonState)
    }
}

// MARK: - action
extension SetNameViewModel {
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
        
        Task {
            let result = await AuthManager.shared.validateNickname(nickname: nickname)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let isDuplicate):
                    if isDuplicate {
                        self.isNickNameVerified.accept(false)
                        self.nickNameStatus.accept(.duplicate)
                    } else {
                        self.isNickNameVerified.accept(true)
                        self.nickNameStatus.accept(.valid)
                    }
                case .failure(let error):
                    print("Nickname validation failed: \(error.localizedDescription)")
                    self.isNickNameVerified.accept(false)
                }
            }
        }
    }
}
