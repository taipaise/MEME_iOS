//
//  ModelReservationConfirmViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import UIKit
import SnapKit

class ModelReservationConfirmViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ModelReservationConfirmViewCell"
    
    @IBOutlet weak var modelReservationDateLabel: UILabel!
    @IBOutlet weak var modelReservationLabel: UILabel!
    @IBOutlet weak var modelReservationMakeupNameLabel: UILabel!
    @IBOutlet weak var modelReservationArtistNameLabel: UILabel!
    @IBOutlet private weak var modelReservationLocationImageView: UIImageView!
    @IBOutlet weak var modelReservationLocationLabel: UILabel!
    @IBOutlet private weak var modelReservationWonLabel: UILabel!
    @IBOutlet weak var modelReservationPriceLabel: UILabel!
    var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .pretendard(to: .regular, size: 10)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("취소하기", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .white
        
        return button
    }()
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        modelReservationLocationImageView.image = UIImage(named: "icon_location")
        setupButton()
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    private func setupButton() {
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {make in
            make.centerY.equalTo(modelReservationWonLabel.snp.centerY).offset(-3)
            make.trailing.equalToSuperview().offset(-22)
            make.width.equalTo(60)
        }
    }

}
