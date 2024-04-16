//
//  ModelSignUpCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class ModelSignUpCoordinator: SignupCoordinator {
    var navigationController: UINavigationController?
    var profileInfo: ProfileInfo
    
    init(navigationController: UINavigationController?, profileInfo: ProfileInfo) {
        self.navigationController = navigationController
        self.profileInfo = profileInfo
    }
    
    @MainActor func start() {
        let vc = SetModelDetailInfoViewController(nibName: SetModelDetailInfoViewController.className, bundle: nil)
        vc.viewModel = SetModelDetailInfoViewModel(profileInfo: profileInfo)
        navigationController?.pushViewController(vc, animated: true)
    }
}
