//
//  FindEmailResultViewModel.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FindEmailResultViewModel: ViewModel {
    struct Input {}
    
    struct Output {
        let email: Observable<String>
    }
    
    private let email: BehaviorRelay<String>
    
    init(email: String) {
        self.email = .init(value: email)
    }
    
    func transform(_ input: Input) -> Output {
        return .init(email: email.asObservable())
    }
}
