//
//  ModelReservationTypeButton.swift
//  MEME
//
//  Created by 정민지 on 1/21/24.
//
import UIKit
import SnapKit

class ModelReservationTypeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.setTitleColor(.black, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.mainBold.cgColor //
        self.layer.cornerRadius = 15
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.titleLabel?.numberOfLines = 1
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
}
