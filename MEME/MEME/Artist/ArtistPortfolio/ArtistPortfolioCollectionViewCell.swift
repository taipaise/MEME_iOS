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
    @IBOutlet var portfolioView: UIView!
    @IBOutlet var fullView: UIView!
    
    static func nib() -> UINib {
        return UINib(nibName: ArtistPortfolioCollectionViewCell.className, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiSet()
    }
    
    private func uiSet(){
        portfolioView.layer.cornerRadius = 10
        portfolioView.layer.shadowOpacity = 0.125
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 7.5
        portfolioView.layer.shadowColor = UIColor(.black).cgColor
        layer.masksToBounds = false
    }

}
