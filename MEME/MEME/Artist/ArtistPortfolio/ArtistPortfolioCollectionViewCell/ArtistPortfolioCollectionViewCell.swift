//
//  ArtistPortfolioCollectionViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/18/24.
//

import UIKit

class ArtistPortfolioCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Properties
    @IBOutlet weak var portfolioImageView: UIImageView!
    @IBOutlet weak var portfolioSubLabel: UILabel!
    @IBOutlet weak var portfolioMainLabel: UILabel!
    @IBOutlet weak var portfolioPriceLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var fullView: UIView!

    static func nib() -> UINib {
        return UINib(nibName: ArtistPortfolioCollectionViewCell.className, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    //MARK: - setUI()
    private func setUI(){
        portfolioImageView.layer.cornerRadius = 10
        portfolioView.layer.cornerRadius = 10
        portfolioView.layer.shadowOpacity = 0.125
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 7.5
        portfolioView.layer.shadowColor = UIColor(.black).cgColor
        layer.masksToBounds = false
    }

}
