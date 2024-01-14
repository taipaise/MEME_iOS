//
//  SelectMakeupCardViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import UIKit

class SelectMakeupCardViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "SelectMakeupCardViewCell"
    
    @IBOutlet weak var makeupCardImageView: UIImageView!
    @IBOutlet weak var artistInformLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
    }
    
    func setupLayer() {
        self.layer.cornerRadius = 10
        
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.1
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.layer.shadowRadius = 10
            self.layer.masksToBounds = false
    }
}
