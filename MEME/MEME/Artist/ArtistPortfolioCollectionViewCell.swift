//
//  ArtistPortfolioCollectionViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/18/24.
//

import UIKit

class ArtistPortfolioCollectionViewCell: UICollectionViewCell {
    @IBOutlet var portfolioImageView: UIImageView!
    @IBOutlet var portfolioSubLabel: UILabel!
    @IBOutlet var portfolioMainLabel: UILabel!
    @IBOutlet var portfolioPriceLabel: UILabel!
    
    static let identifier = "ArtistPortfolioCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "ArtistPortfolioCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
