//
//  NavigationController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

final class NavigationController: UINavigationController {
    
    private var isPushing: Bool = false
    private var backButtonItem: UIBarButtonItem {
        return .init(
            image: .icBack,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushing = true
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func didTapBackButton() {
        super.popViewController(animated: true)
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard navigationController.viewControllers.first != viewController else {
            navigationController.setNavigationBarHidden(true, animated: false)
            return
        }
        navigationController.setNavigationBarHidden(false, animated: false)
        viewController.navigationItem.leftBarButtonItem = backButtonItem
        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isPushing = false
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard
            gestureRecognizer == interactivePopGestureRecognizer,
            viewControllers.count > 1,
            isPushing == false
        else { return false }
        
        return true
    }
    
}
