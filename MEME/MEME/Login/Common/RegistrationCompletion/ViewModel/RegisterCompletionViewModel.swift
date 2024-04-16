//
//  RegisterCompletionViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class RegisterCompletionViewModel {
    
    private(set) var role: RoleType
    private(set) var nickName = BehaviorRelay<String>(value: "")
    
    init(role: RoleType) {
        self.role = role
        let name = KeyChainManager.read(forkey: .nickName) ?? ""
        nickName.accept(name)
    }
}
