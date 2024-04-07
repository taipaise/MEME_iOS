//
//  ModelMainCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class ModelMainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let vc = ModelTabBarController()
        navigationController?.viewControllers = [vc]
    }
    
}
