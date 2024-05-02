//
//  ViewModel.swift
//  MEME
//
//  Created by 이동현 on 3/9/24.
//

import Foundation
import RxSwift

@MainActor
protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
