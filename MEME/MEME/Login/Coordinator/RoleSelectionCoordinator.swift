//
//  RoleSelectionCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class RoleSelectionCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let vc = RoleSelectionViewController(nibName: RoleSelectionViewController.className, bundle: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
