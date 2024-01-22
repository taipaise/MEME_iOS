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
    
    @IBOutlet private weak var modelReservationDateLabel: UILabel!
    @IBOutlet private weak var modelReservationLabel: UILabel!
    @IBOutlet private weak var modelReservationMakeupNameLabel: UILabel!
    @IBOutlet private weak var modelReservationArtistNameLabel: UILabel!
    @IBOutlet private weak var modelReservationLocationImageView: UIImageView!
    @IBOutlet private weak var modelReservationLocationLabel: UILabel!
    @IBOutlet private weak var modelReservationWonLabel: UILabel!
    @IBOutlet private weak var modelReservationPriceLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        modelReservationLocationImageView.image = UIImage(named: "icon_location")
        setupButton()
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    private func setupButton() {
        cancelButton.layer.cornerRadius = 15
        cancelButton.titleLabel?.font = .pretendard(to: .regular, size: 10)
        cancelButton.setTitleColor(.black, for: .normal)
    }

}
