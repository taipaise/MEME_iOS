//
//  RoleSelectionViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class RoleSelectionViewModel: ViewModel {
    struct Input {
        let modelTap: Observable<Void>
        let artistTap: Observable<Void>
    }
    
    struct Output {
        let selectedType: Observable<RoleType?>
        let nextButtonState: Observable<Bool>
    }
    
    private(set) var roleType = BehaviorRelay<RoleType?>(value: nil)
    private let nextButtonState = BehaviorRelay<Bool>(value: false)
    private var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.modelTap
            .subscribe { [weak self] _ in
                self?.roleType.accept(.MODEL)
                self?.nextButtonState.accept(true)
            }
            .disposed(by: disposeBag)
        
        input.artistTap
            .subscribe { [weak self] _ in
                self?.roleType.accept(.ARTIST)
                self?.nextButtonState.accept(true)
            }
            .disposed(by: disposeBag)
        
        return Output(
            selectedType: roleType.asObservable(),
            nextButtonState: nextButtonState.asObservable()
        )
    }
}
