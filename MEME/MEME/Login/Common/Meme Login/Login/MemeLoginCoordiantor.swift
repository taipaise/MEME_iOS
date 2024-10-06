//
//  MemeLoginCoordiantor.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit

final class MemeLoginCoordiantor: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let vc = MemeLoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
