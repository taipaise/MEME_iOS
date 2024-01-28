//
//  ModalPresentationController.swift
//  MEME
//
//  Created by 정민지 on 1/21/24.
//

import UIKit
import SnapKit

class ModalPresentationController: UIPresentationController {
    // MARK: - Properties
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1) 
        return view
    }()

    // MARK: -frameOfPresentedViewInContainerView
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        return CGRect(x: 0, y: containerView.bounds.height - 200, width: containerView.bounds.width, height: 200)
    }
    
    // MARK: -presentationTransitionWillBegin
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
                
        containerView.addSubview(backgroundView)
        backgroundView.frame = containerView.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
        // MARK: -Add tapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        backgroundView.addGestureRecognizer(tapGesture)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.backgroundView.alpha = 1.0
            })
        } else {
            backgroundView.alpha = 1.0
        }
    }
    
    // 바깥쪽 누르면 모달 닫히는 효과
    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true)
    }

    // 모달 뷰 코너 라운딩
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.roundCorners([.topLeft, .topRight], radius: 10)
    }
}

// MARK: -roundCorners
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

