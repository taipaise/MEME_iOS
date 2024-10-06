//
//  ResetPasswordViewModel.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ResetPasswordViewModel: ViewModel {
    enum PasswordState {
        case invalid
        case different
        case valid
        case none
    }
    
    struct Input {
        let inputPassword: Observable<String?>
        let inputVerification: Observable<String?>
        let requestReset: Observable<Void>
    }
    
    struct Output {
        let passwordState: Observable<PasswordState>
        let requestCompleted: Observable<Void>
    }
    
    private var password = BehaviorRelay(value: "")
    private var verification = BehaviorRelay(value: "")
    private var passwordState = BehaviorRelay<PasswordState>(value: .none)
    private var requestCompleted = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.inputPassword
            .withUnretained(self)
            .subscribe { (self, password) in
                self.password.accept(password ?? "")
                self.inputPasswordChanged()
            }
            .disposed(by: disposeBag)
        
        input.inputVerification
            .withUnretained(self)
            .subscribe { (self, verification) in
                self.verification.accept(verification ?? "")
                self.inputPasswordChanged()
            }
            .disposed(by: disposeBag)
        
        input.requestReset
            .withUnretained(self)
            .subscribe { (self, _) in
                self.requestResetPassword()
            }
            .disposed(by: disposeBag)
        
        return .init(
            passwordState: passwordState.asObservable(),
            requestCompleted: requestCompleted.asObservable()
        )
    }
}

extension ResetPasswordViewModel {
    private func inputPasswordChanged() {
        let password = password.value
        let verification = verification.value
        
        guard
            !password.isEmpty,
            !verification.isEmpty
        else {
            passwordState.accept(.none)
            return
        }
        
        guard isValidPassword(password) else {
            passwordState.accept(.invalid)
            return
        }
        
        guard password == verification else {
            passwordState.accept(.different)
            return
        }
        
        passwordState.accept(.valid)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,20}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}

extension ResetPasswordViewModel {
    private func requestResetPassword() {
        Task {
            requestCompleted.onNext(())
        }
    }
}
