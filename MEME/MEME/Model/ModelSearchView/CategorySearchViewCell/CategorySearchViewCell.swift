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
    @IBOutlet private weak var categoryImageBackgroundView: UIView!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradientBackground()
    }
    
    private func setupGradientBackground() {
        categoryImageBackgroundView.layer.cornerRadius = 20
        categoryImageBackgroundView.layer.masksToBounds = true
        
        categoryImageBackgroundView.layer.borderWidth = 5
        categoryImageBackgroundView.layer.borderColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 0.4).cgColor
        
        let gradient = CAGradientLayer()
        gradient.frame = categoryImageBackgroundView.bounds
        gradient.colors = [
            UIColor(red: 255/255, green: 120/255, blue: 88/255, alpha: 0.21).cgColor,
            UIColor(red: 255/255, green: 155/255, blue: 131/255, alpha: 0.25).cgColor,
            UIColor(red: 255/255, green: 245/255, blue: 243/255, alpha: 0.05).cgColor,
            UIColor(red: 255/255, green: 102/255, blue: 66/255, alpha: 0.20).cgColor
        ]
        gradient.locations = [0.0658, 0.0659, 0.2571, 0.7944]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)

        categoryImageBackgroundView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        categoryImageBackgroundView.layer.insertSublayer(gradient, at: 0)
        }
    }
