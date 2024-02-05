//
//  UIView+.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

public extension UIView {
    
    func loadNib() {
        let bundle = type(of: self).bundle
        let nibName = type(of: self).className
        
        guard let nibs = bundle.loadNibNamed(nibName, owner: self, options: nil) else { return }
        guard let nib = nibs.first as? UIView else { return }
        
        nib.frame = bounds
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nib)
    }
    
    func setGradient(
        color1: UIColor,
        color2: UIColor,
        startPoint: CGPoint,
        endPoint: CGPoint,
        location: [NSNumber],
        cornerRadius: CGFloat
    ) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = location
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds
        gradient.cornerRadius = cornerRadius
        layer.insertSublayer(gradient, at: 0)
    }
    
    func removeSubLayers() {
        let layers = layer.sublayers
        layers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
    
    func setupDismissKeyboardOnTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
