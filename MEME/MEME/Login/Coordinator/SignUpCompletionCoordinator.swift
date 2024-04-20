//
//  SignUpCompletionCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/14/24.
//

import UIKit

final class SignUpCompletionCoordinator: SignupCoordinator {
    var navigationController: UINavigationController?
    
    var profileInfo: SignUpProfileInfo
    
    init(navigationController: UINavigationController?, profileInfo: SignUpProfileInfo) {
        self.navigationController = navigationController
        self.profileInfo = profileInfo
    }
    
    @MainActor func start() {
        let vc = RegistrationCompletionViewController(nibName: RegistrationCompletionViewController.className, bundle: nil)
        vc.viewModel = RegisterCompletionViewModel(role: profileInfo.roleType)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @MainActor func start(isSuccess: Bool) {
        let alert = UIAlertController(title: "알림", message: "회원가입에 실패했습니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(confirm)
        
        if isSuccess {
            start()
        } else {
            navigationController?.present(alert, animated: true)
        }
    }
}
