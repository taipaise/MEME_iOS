//
//  TimeCollectionView.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import UIKit
import SnapKit

final class ArtistTimeCollectionViewCell: UICollectionViewCell {
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setLayout()
    }
    
    private func setUI() {
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray300.cgColor
    }
    
    private func setLayout() {
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(time: String) {
        timeLabel.text = time
    }
    
    func getTime() -> String {
        return timeLabel.text ?? ""
    }
}
