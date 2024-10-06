//
//  MemeSignUpCoordinator.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import UIKit

final class MemeSignUpCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let vc = MemeSignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
