//
//  RegisterProgressBar.swift
//  MEME
//
//  Created by 이동현 on 1/17/24.
//

import UIKit

final class RegisterProgressBar: UIView {

    @IBOutlet private weak var view1: UIView!
    @IBOutlet private weak var view2: UIView!
    @IBOutlet private weak var view3: UIView!
    private lazy var views = [view1, view2, view3]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        loadNib()
        
        views.forEach {
            $0?.layer.cornerRadius = 1.5
            $0?.layer.masksToBounds = true
        }
    }
    
    func configure(progress: Int) {
        views.enumerated().forEach { index, view in
            if index == progress {
                view?.backgroundColor = .mainBold
            } else {
                view?.backgroundColor = .gray300
            }
        }
    }
}
