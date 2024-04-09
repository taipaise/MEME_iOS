//
//  ArtistMainCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class ArtistMainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let vc = ArtistTabBarController()
        navigationController?.viewControllers = [vc]
    }
    
}
