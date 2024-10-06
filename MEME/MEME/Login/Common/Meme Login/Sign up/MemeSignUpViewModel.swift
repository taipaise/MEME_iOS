//
//  MemeSignUpViewModel.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MemeSignUpViewModel: ViewModel {
    enum FetchVerificationCodeState {
        case none
        case canRequest
        case failure
        case success
    }
    
    enum VerificationCodeState {
        case retry
        case valid
        case invalid
        case error
    }
    
    enum PasswordState {
        case invalid
        case different
        case valid
        case none
    }
    
   struct Input {
       let inputEmail: Observable<String?>
       let requestCode: Observable<Void>
       let inputCode: Observable<String?>
       let inputPassword: Observable<String?>
       let inputPasswordVerfication: Observable<String?>
    }
    
    struct Output {
        let fetchVerificationState: Observable<FetchVerificationCodeState>
        let verificationCodeState: Observable<VerificationCodeState>
        let passwordState: Observable<PasswordState>
        let isAllValid: Observable<Bool>
    }
    
    private var email = BehaviorRelay(value: "")
    private var fetchVerificationState = BehaviorRelay<FetchVerificationCodeState>(value: .none)
    private var reqeustCodeCompleted = PublishSubject<Void>()
    private var verificationCode = ""
    private var userVerificationCode = BehaviorRelay(value: "")
    private var verificationCodeState = BehaviorRelay<VerificationCodeState>(value: .invalid)
    private(set) var leftTime = BehaviorRelay(value: 180)
    private var password = BehaviorRelay(value: "")
    private var passwordVerification = BehaviorRelay(value: "")
    private var passwordState = BehaviorRelay<PasswordState>(value: .none)
    private var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.inputEmail
            .withUnretained(self)
            .subscribe { (self, email) in
                if
                    let email = email,
                    !email.isEmpty
                {
                    self.fetchVerificationState.accept(.canRequest)
                } else {
                    self.fetchVerificationState.accept(.none)
                }
                self.email.accept(email ?? "")
            }
            .disposed(by: disposeBag)
        
        input.inputCode
            .withUnretained(self)
            .subscribe { (self, code) in
                self.userVerificationCode.accept(code ?? "")
                self.handleVerificationCode()
            }
            .disposed(by: disposeBag)
        
        input.inputPassword
            .withUnretained(self)
            .subscribe { (self, password) in
                self.password.accept(password ?? "")
                self.inputPasswordChanged()
            }
            .disposed(by: disposeBag)
        
        input.inputPasswordVerfication
            .withUnretained(self)
            .subscribe { (self, passwordVerification) in
                self.passwordVerification.accept(passwordVerification ?? "")
                self.inputPasswordChanged()
            }
            .disposed(by: disposeBag)
        
        input.requestCode
            .withUnretained(self)
            .subscribe { (self, _) in
                self.fetchVerificationCode()
            }
            .disposed(by: disposeBag)
        
        let isAllValid = Observable.combineLatest(verificationCodeState, passwordState)
            .map { $0 == .valid && $1 == .valid }
            .distinctUntilChanged()

        return .init(
            fetchVerificationState: fetchVerificationState.asObservable(),
            verificationCodeState: verificationCodeState.asObservable(),
            passwordState: passwordState.asObservable(),
            isAllValid: isAllValid
        )
    }
}

// MARK: - handle verification code
extension MemeSignUpViewModel {
    private func handleVerificationCode() {
        let leftTime = leftTime.value
        let code = userVerificationCode.value
        
        guard
            !code.isEmpty,
            code == verificationCode,
            leftTime >= 0
        else {
            verificationCodeState.accept(.invalid)
            return
        }
        verificationCodeState.accept(.valid)
    }
    
    func reduceTime() {
        var leftTime = leftTime.value
        leftTime -= 1
        self.leftTime.accept(leftTime)
    }
    
    func fetchVerificationCode() {
        Task {
            verificationCode = "0000"
            fetchVerificationState.accept(.success)
            verificationCodeState.accept(.retry)
            leftTime.accept(180)
        }
    }
}

// MARK: - handle password
extension MemeSignUpViewModel {
    private func inputPasswordChanged() {
        let password = password.value
        let verification = passwordVerification.value
        
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

