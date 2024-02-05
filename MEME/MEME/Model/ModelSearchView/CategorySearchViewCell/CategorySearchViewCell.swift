//
//  CategorySearchViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import Foundation
import UIKit

class CategorySearchViewCell: UICollectionViewCell {
    static let identifier = "CategorySearchViewCell"
    @IBOutlet private weak var categoryBackgroundImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradientBackground()
    }
    
    private func setupGradientBackground() {
        categoryBackgroundImageView.layer.cornerRadius = 20
        categoryBackgroundImageView.layer.masksToBounds = true
        categoryBackgroundImageView.image = UIImage(named: "categoryBackgroundImage")
        
    }
}
