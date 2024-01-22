//
//  ModelNonReservationViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/14/24.
//

import UIKit

class ModelNonReservationViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ModelNonReservationViewCell"
    
    @IBOutlet private weak var modelNoReservationLabel: UILabel!
    @IBOutlet private weak var modelNoReservationButton: UIButton!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    private func setupButton() {
        modelNoReservationButton.titleLabel?.font = .pretendard(to: .regular, size: 14)
        modelNoReservationButton.setTitleColor(.white, for: .normal)
    }
}
