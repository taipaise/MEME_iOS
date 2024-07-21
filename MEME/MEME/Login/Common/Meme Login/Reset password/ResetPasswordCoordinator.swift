//
//  ResetPasswordCoordinator.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit

final class ResetPasswordCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let vc = ResetPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
