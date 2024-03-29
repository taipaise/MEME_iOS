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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonImage: UIImageView!
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
    
    func configure(title: String, backButtonisHidden: Bool = false) {
        titleLabel.text = title
        backButton.isHidden = backButtonisHidden
        backButtonImage.isHidden = backButtonisHidden
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.backButtonTapped()
    }
    
}
