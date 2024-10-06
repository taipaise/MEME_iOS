//
//  UITextField+.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit

extension UITextField {
    /// text의 왼쪽 여백을 설정하는 함수
    /// - Parameter:
    ///   - padding: 여백 값
    func addLeftPadding(padding: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: padding,
                height: self.frame.height
            )
        )
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
