//
//  TermDetailViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TermDetailViewModel: ViewModel {
    struct Input {}
    struct Output {
        let title: Observable<String>
        let content: Observable<String>
    }
    
    private let title = BehaviorRelay(value: "")
    private let content = BehaviorRelay(value: "")
    
    init(termType: TermsData) {
        title.accept(termType.title)
        content.accept(termType.data)
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            title: title.asObservable(),
            content: content.asObservable()
        )
    }
}
