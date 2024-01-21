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
    
    @IBOutlet weak var modelNoReservationLabel: UILabel!
    @IBOutlet weak var modelNoReservationButton: UIButton!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
