//
//  SignUpCompletionCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/14/24.
//

import UIKit

final class SignUpCompletionCoordinator {
    
    var navigationController: UINavigationController?
    var role: RoleType
    
    init(navigationController: UINavigationController?, roleType: RoleType) {
        self.navigationController = navigationController
        role = roleType
    }
    
    @MainActor func start(isSuccess: Bool) {
        let alert = UIAlertController(title: "알림", message: "회원가입에 실패했습니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(confirm)
        
        if isSuccess {
            let vc = RegistrationCompletionViewController(nibName: RegistrationCompletionViewController.className, bundle: nil)
            vc.viewModel = RegisterCompletionViewModel(role: role)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            navigationController?.present(alert, animated: true)
        }
        
    }
}
