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
}
