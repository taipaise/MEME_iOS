//
//  SetProfileDetailCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class SetNameCoordinator: SignupCoordinator {
    var navigationController: UINavigationController?
    
    var profileInfo: SignUpProfileInfo
    
    init(navigationController: UINavigationController?, profileInfo: SignUpProfileInfo) {
        self.navigationController = navigationController
        self.profileInfo = profileInfo
    }

    @MainActor func start() {
        let vc = SetNameViewController(nibName: SetNameViewController.className, bundle: nil)
        let viewModel = SetNameViewModel(profileInfo: profileInfo)
        vc.configure(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
