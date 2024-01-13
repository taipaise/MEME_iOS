//
//  OnboardingCollectionViewCell.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import SnapKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView = UIImageView()
    
    override func awakeFromNib() {
        setLayout()
        super.awakeFromNib()
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
    
    private func setLayout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
