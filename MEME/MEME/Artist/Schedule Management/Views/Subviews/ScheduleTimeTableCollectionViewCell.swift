//
//  ScheduleTimeTableCollectionViewCell.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import UIKit
import SnapKit

struct ScheduleTimeTableCellModel: Identifiable {
    var id = UUID()
    let type: TimeType
    let time: ReservationTimes
    let hour: Int
    let min: Int
    var selected = false
}

final class ScheduleTimeTableCollectionViewCell: UICollectionViewCell {
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private var cellModel: ScheduleTimeTableCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        addSubViews()
        makeConstraints()
        setUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        guard let cellModel = cellModel else { return }
        if cellModel.selected {
            contentView.layer.borderColor = UIColor.mainBold.cgColor
        } else {
            contentView.layer.borderColor = UIColor.gray400.cgColor
        }
    }
    
    private func setUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
    }
    
    func configure(_ cellModel: ScheduleTimeTableCellModel) {
        self.cellModel = cellModel
        timeLabel.text = String(format: "%02d:%02d", cellModel.hour, cellModel.min)
        if cellModel.selected {
            contentView.layer.borderColor = UIColor.mainBold.cgColor
        } else {
            contentView.layer.borderColor = UIColor.gray400.cgColor
        }
    }
}

// MARK: - layout configuration
extension ScheduleTimeTableCollectionViewCell {
    private func addSubViews() {
        contentView.addSubview(timeLabel)
    }
    
    private func makeConstraints() {
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
