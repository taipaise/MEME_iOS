//
//  TermsAgreementViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TermsAgreementViewModel: ViewModel {
    struct Input {
        let entireButtonTap: Observable<Int>
        let firstAgreementButtonTap: Observable<Int>
        let secondAgreementButtonTap: Observable<Int>
    }
    
    struct Output {
        let entireAgreeButtonState: Observable<Bool>
        let firstAgreeButtonState: Observable<Bool>
        let secondAgreeButtonState: Observable<Bool>
        let nextButtonState: Observable<Bool>
    }
    
    private let entireAgreeButtonState = BehaviorRelay<Bool>(value: false)
    private let firstAgreeButtonState = BehaviorRelay<Bool>(value: false)
    private let secondAgreeButtonState = BehaviorRelay<Bool>(value: false)
    private let nextButtonState = BehaviorRelay<Bool>(value: false)
    private var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        [
            input.entireButtonTap,
            input.firstAgreementButtonTap,
            input.secondAgreementButtonTap
        ].forEach({ buttonInput in
            buttonInput.bind { [weak self] tag in
                print("tag: \(tag)")
                self?.toggleAgreementState(type: ButtonType(rawValue: tag) ?? .entire)
            }
            .disposed(by: disposeBag)
        })
        
        let isAllTermsAgreed = Observable.combineLatest(firstAgreeButtonState, secondAgreeButtonState)
            .map { $0 && $1 }
            .distinctUntilChanged()
        isAllTermsAgreed.bind(to: self.entireAgreeButtonState, nextButtonState).disposed(by: disposeBag)
        
        return Output(
            entireAgreeButtonState: entireAgreeButtonState.asObservable(),
            firstAgreeButtonState: firstAgreeButtonState.asObservable(),
            secondAgreeButtonState: secondAgreeButtonState.asObservable(),
            nextButtonState: nextButtonState.asObservable()
        )
    }
}

extension TermsAgreementViewModel {
    enum ButtonType: Int {
        case entire
        case first
        case second
    }
    
    private func toggleAgreementState(type: ButtonType) {
        switch type {
        case .entire:
            let state = entireAgreeButtonState.value
            firstAgreeButtonState.accept(!state)
            secondAgreeButtonState.accept(!state)
        case .first:
            let state = firstAgreeButtonState.value
            firstAgreeButtonState.accept(!state)
        case .second:
            let state = secondAgreeButtonState.value
            secondAgreeButtonState.accept(!state)
        }
    }
}
