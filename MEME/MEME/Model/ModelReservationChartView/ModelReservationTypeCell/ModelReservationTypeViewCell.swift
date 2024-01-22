//
//  ModelReservationTypeViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/20/24.
//
import UIKit

class ModelReservationTypeViewCell: UICollectionViewCell {
    static let identifier = "ModelReservationTypeViewCell"
    
    private let button: UIButton = {
            let button = UIButton(type: .system)
            button.setTitleColor(.mainBold, for: .normal)

            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.backgroundColor = .mainBold
            return button
        }()
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

    }


}
