//
//  TermsAgreementCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

final class TermDetailCoordinator {
    weak var presentingVC: UIViewController?
    
    init(presentingVC: UIViewController?) {
        self.presentingVC = presentingVC
    }
    
    @MainActor func start(termType: TermsData) {
        let termDeatilVC = TermDetailViewController(
            nibName: TermDetailViewController.className,
            bundle: nil
        )
        
        termDeatilVC.modalPresentationStyle = .fullScreen
        termDeatilVC.configure(termType: termType)
        presentingVC?.present(termDeatilVC, animated: true)
    }
}
