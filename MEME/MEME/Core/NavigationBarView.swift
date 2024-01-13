//
//  NavigationBarView.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

protocol BackButtonTappedDelegate: AnyObject {
    func backButtonTapped()
}

final class NavigationBarView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: BackButtonTappedDelegate?
    
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
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.backButtonTapped()
    }
    
}
