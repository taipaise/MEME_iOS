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
    
    private(set) var profileInfo: SignUpProfileInfo
    private(set) var nickName = BehaviorRelay<String>(value: "")
    
    init(profileInfo: SignUpProfileInfo) {
        self.profileInfo = profileInfo
        nickName.accept(profileInfo.nickname)
    }
}
