//
//  ArtistMakeupTagCollectionViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/18/24.
//

import UIKit

class ArtistMakeupTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var makeupTagLabel: UILabel!
    
    static let identifier = "ArtistMakeupTagCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "ArtistMakeupTagCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
