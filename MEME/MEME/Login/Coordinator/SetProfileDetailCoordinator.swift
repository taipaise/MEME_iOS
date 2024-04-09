//
//  SetProfileDetailCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class SetProfileDetailCoordinator {
    private var navigationController: UINavigationController?
    private var roleType: RoleType
    
    init(navigationController: UINavigationController?, roleType: RoleType) {
        self.navigationController = navigationController
        self.roleType = roleType
    }
    
    @MainActor func start() {
        let vc = SetProfileViewController(nibName: SetProfileViewController.className, bundle: nil)
        vc.configure(viewModel: SetProfileViewModel(roleType: roleType))
        navigationController?.pushViewController(vc, animated: true)
    }
}
