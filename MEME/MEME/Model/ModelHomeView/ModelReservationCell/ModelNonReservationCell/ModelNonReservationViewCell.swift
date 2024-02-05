//
//  ModelNonReservationViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/14/24.
//

import UIKit
import SnapKit

class ModelNonReservationViewCell: UICollectionViewCell {
    // MARK: - Properties
    var onReservationTapped: (() -> Void)?
    
    static let identifier = "ModelNonReservationViewCell"
    
    private var modelNoReservationLabel: UILabel = {
        let label = UILabel()
        label.text = "예정된 약속이 없어요. 🥲\n지금 예약하러 가볼까요?"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 18)
        label.numberOfLines = 0
        
        return label
    }()
    
    private var modelNoReservationButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("메이크업 예약하기", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(reservationTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        makeConstraints()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    private func configureSubviews() {
        contentView.addSubview(modelNoReservationButton)
        contentView.addSubview(modelNoReservationLabel)
    }
    
    // MARK: - makeConstraints
    private func makeConstraints() {
        modelNoReservationButton.snp.makeConstraints {make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        modelNoReservationLabel.snp.makeConstraints {make in
            make.bottom.equalTo(modelNoReservationButton.snp.top).offset(-30)
            make.centerX.equalToSuperview()
        }
    }
    // MARK: - Action
    @objc private func reservationTapped() {
        onReservationTapped?()
    }
}
