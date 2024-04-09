//
//  ArtistSignUpCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class ArtistSignUpCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let vc = BusinessRegistrationViewController(nibName: BusinessRegistrationViewController.className, bundle: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
