//
//  NotificationCollectionViewCell.swift
//  MEME
//
//  Created by 이동현 on 7/15/24.
//

import UIKit
import SnapKit

struct NotificationCellModel: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let type: NotificationType
    var isRead: Bool
}

final class NotificationCollectionViewCell: UICollectionViewCell {
    private lazy var background: UIView = {
        let view = UIView()
        view.alpha = 0.1
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .semiBold, size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .medium, size: 10)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    private(set) var cellModel: NotificationCellModel?
    
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
    }
    
    func configure(_ cellModel: NotificationCellModel) {
        self.cellModel = cellModel
        titleLabel.text = cellModel.title
        contentLabel.text = cellModel.content
        iconImageView.image = cellModel.type.icon
        if cellModel.isRead {
            background.backgroundColor = .white
        } else {
            background.backgroundColor = .notificationBackground
        }
    }
}

extension NotificationCollectionViewCell {
    private func addSubViews() {
        contentView.addSubViews([
            background,
            iconImageView,
            titleLabel,
            contentLabel
        ])
    }
    
    private func makeConstraints() {
        background.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.size.equalTo(29)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.leading.equalTo(titleLabel)
        }
    }
}
