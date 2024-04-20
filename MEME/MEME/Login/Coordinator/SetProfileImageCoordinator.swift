//
//  SetProfileImageCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/20/24.
//

import UIKit

final class SetProfileImageCoordinator: SignupCoordinator {
    var navigationController: UINavigationController?
    var profileInfo: SignUpProfileInfo
    
    init(navigationController: UINavigationController?, profileInfo: SignUpProfileInfo) {
        self.navigationController = navigationController
        self.profileInfo = profileInfo
    }
    
    @MainActor func start() {
        let vc = SetProfileViewController(nibName: SetProfileViewController.className, bundle: nil)
        let viewModel = SetProfileViewModel(roleType: .MODEL)
        vc.configure(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
