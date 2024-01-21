//
//  ModelReservationConfirmViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import UIKit

class ModelReservationConfirmViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ModelReservationConfirmViewCell"
    
    @IBOutlet weak var modelReservationDateLabel: UILabel!
    @IBOutlet weak var modelReservationLabel: UILabel!
    @IBOutlet weak var modelReservationMakeupNameLabel: UILabel!
    @IBOutlet weak var modelReservationArtistNameLabel: UILabel!
    @IBOutlet weak var modelReservationLocationImageView: UIImageView!
    @IBOutlet weak var modelReservationLocationLabel: UILabel!
    @IBOutlet weak var modelReservationWonLabel: UILabel!
    @IBOutlet weak var modelReservationPriceLabel: UILabel!

    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        modelReservationLocationImageView.image = UIImage(named: "icon_location")
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

}
