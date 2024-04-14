//
//  ModelDetailInfoCollectionViewCell.swift
//  MEME
//
//  Created by 이동현 on 4/14/24.
//

import UIKit
import SnapKit

struct ModelDetailCellModel: Hashable {
    let title: String
    var isSelected: Bool
}

final class ModelDetailInfoCollectionViewCell: UICollectionViewCell {
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        return view
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 14)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override func prepareForReuse() {
        backgroundImageView.image = nil
    }
    
    private func initialize() {
        addSubViews()
        makeConstraints()
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    func configure(_ cellModel: ModelDetailCellModel) {
        contentLabel.text = cellModel.title
        if cellModel.isSelected {
            backgroundImageView.image = .detailSelected
            contentView.layer.borderColor = UIColor.clear.cgColor
        } else {
            backgroundImageView.image = nil
            contentView.layer.borderColor = UIColor.gray400.cgColor
        }
    }
}

// MARK: - layout configuration
extension ModelDetailInfoCollectionViewCell {
    private func addSubViews() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(contentLabel)
    }
    
    private func makeConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
