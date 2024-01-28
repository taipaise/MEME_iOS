//
//  RecentSearchViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import UIKit

class RecentSearchViewCell: UICollectionViewCell {
    static let identifier = "RecentSearchViewCell"
    @IBOutlet weak var searchWordLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
    }
    
    func setupLayer() {
        self.layer.cornerRadius = 13
        self.layer.borderColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }

}
