//
//  CALayer+.swift
//  MEME
//
//  Created by 이동현 on 4/21/24.
//

import UIKit

extension CALayer {
    
    func addBottomBorder(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: frame.height - height, width: frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.addSublayer(border)
    }
}
