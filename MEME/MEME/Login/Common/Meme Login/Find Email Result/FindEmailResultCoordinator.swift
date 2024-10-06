//
//  FindEmailResultCoordinator.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import UIKit

final class FindEmailResultCoordinator {
    private let navigationController: UINavigationController?
    private let email: String
    
    init(
        navigationController: UINavigationController?,
        email: String
    ) {
        self.navigationController = navigationController
        self.email = email
    }
    
    @MainActor func start() {
        let vc = FindEmailResultViewController(email: email)
        navigationController?.pushViewController(vc, animated: true)
    }
}
