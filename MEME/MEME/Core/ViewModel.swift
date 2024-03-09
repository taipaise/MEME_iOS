//
//  ViewModel.swift
//  MEME
//
//  Created by 이동현 on 3/9/24.
//

import Foundation
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(_ input: Input) -> Output
}
