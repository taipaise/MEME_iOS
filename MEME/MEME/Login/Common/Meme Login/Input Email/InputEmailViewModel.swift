//
//  FindAccountViewModel.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import Foundation
import RxSwift
import RxCocoa

enum FindAccountMode {
    case findEmail
    case findPassword
    
    var description: String {
        switch self {
        case .findEmail:
            return "메메에서 사용하는 닉네임을\n입력해주세요"
        case .findPassword:
            return "메메에서 사용하는 이메일을\n입력해주세요"
        }
    }
    
    var placeholder: String {
        switch self {
        case .findEmail:
            return "닉네임을 입력해주세요"
        case .findPassword:
            return "이메일을 입력해주세요"
        }
    }
}

final class InputEmailViewModel: ViewModel {
    enum UserInfoStatus {
        case networkError
        case valid
        case invalid
        case none
    }
    
    struct Input {
        let inputInfo: Observable<String?>
        let requestFind: Observable<Void>
    }
    
    struct Output {
        var userInfoStatus: Observable<UserInfoStatus>
    }
    
    private(set) var mode: FindAccountMode
    private var verificationCode: String? // 서버로부터 받은 인증코드
    private var email: String? // 서버로부터 받은 계정 이메일
    private var userInfoString = "" // 사용자가 입력한 이메일 또는 닉네임
    private var userInfoStatus = BehaviorRelay<UserInfoStatus>(value: .none)
    private var disposeBag = DisposeBag()
    
    init(_ mode: FindAccountMode) {
        self.mode = mode
    }
    
    func transform(_ input: Input) -> Output {
        input.inputInfo
            .withUnretained(self)
            .subscribe { (self, emailCode) in
                self.userInfoChanged(emailCode)
            }
            .disposed(by: disposeBag)
        
        input.requestFind
            .withUnretained(self)
            .subscribe { (self, _) in
                self.requestFind()
            }
            .disposed(by: disposeBag)
        
        return .init(
            userInfoStatus: userInfoStatus.asObservable()
        )
    }
}

extension InputEmailViewModel {
    private func userInfoChanged(_ userInfo: String?) {
        self.userInfoString = userInfo ?? ""
        userInfoStatus.accept(.none)
    }
    
    private func requestFind() {
        switch mode {
        case .findEmail:
            fetchEmail()
        case .findPassword:
            reqeustVerificationCode()
        }
    }
}

extension InputEmailViewModel {
    func fetchEmail() {
        Task {
            email = "taipaise@gmail.com"
        }
    }
    
    func reqeustVerificationCode() {
        Task {
            verificationCode = "0000"
        }
    }
}
