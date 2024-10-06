//
//  MemeEmailCoordinator.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit

final class InputEmailCoordinator {
    
    private let navigationController: UINavigationController?
    private let mode: FindAccountMode
    
    init(
        navigationController: UINavigationController?,
        mode: FindAccountMode
    ) {
        self.navigationController = navigationController
        self.mode = mode
    }
    
    @MainActor func start() {
        let vc = InputEmailViewController(mode: mode)
        navigationController?.pushViewController(vc, animated: true)
    }
}
