//
//  InputVerificationCodeCoordinator.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit

final class InputVerificationCodeCoordinator {
    
    private let navigationController: UINavigationController?
    private let code: String
    
    init(
        navigationController: UINavigationController?,
        code: String
    ) {
        self.navigationController = navigationController
        self.code = code
    }
    
    @MainActor func start() {
        let vc = InputVerificationCodeViewController(code: code)
        navigationController?.pushViewController(vc, animated: true)
    }
}
