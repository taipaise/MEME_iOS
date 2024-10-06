//
//  InputVerificationCodeViewModel.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class InputVerificationCodeViewModel: ViewModel {
    enum VerificationState {
        case retry
        case valid
        case invalid
        case error
    }
    
    struct Input {
        let inputVerificationCode: Observable<String?>
    }
    
    struct Output {
        let isCorrectCode: Observable<VerificationState>
    }
    
    var leftTime = BehaviorRelay(value: 180)
    private var verificationCode: String
    private var inputCode = BehaviorRelay<String?>(value: nil)
    private let codeState = BehaviorRelay<VerificationState>(value: .invalid)
    private var disposeBag = DisposeBag()
    
    init(code: String) {
        verificationCode = code
        leftTime
            .withUnretained(self)
            .subscribe { (self, _) in
                self.handleVerificationCode()
            }
            .disposed(by: disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        input.inputVerificationCode
            .withUnretained(self)
            .subscribe { (self, code) in
                self.inputCode.accept(code)
                self.handleVerificationCode()
            }
            .disposed(by: disposeBag)
        
        return .init(
            isCorrectCode: codeState.asObservable()
        )
    }
}

extension InputVerificationCodeViewModel {
    func resetTimer() {
        fetchVerificationCode()
        leftTime.accept(180)
    }
    
    func reduceTime() {
        var leftTime = leftTime.value
        leftTime -= 1
        self.leftTime.accept(leftTime)
    }
    
    private func handleVerificationCode() {
        let leftTime = leftTime.value
        guard let code = inputCode.value else { return }
        
        guard
            code == verificationCode,
            leftTime >= 0
        else {
            codeState.accept(.invalid)
            return
        }
        codeState.accept(.valid)
    }
}

extension InputVerificationCodeViewModel {
    private func fetchVerificationCode() {
        Task {
            verificationCode = "0000"
            codeState.accept(.retry)
        }
    }
}
