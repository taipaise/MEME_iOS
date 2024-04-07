//
//  SetProfileDetailCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class SetProfileDetailCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let vc = SetProfileViewController(nibName: SetProfileViewController.className, bundle: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
