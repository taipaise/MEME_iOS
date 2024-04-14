//
//  ModelDetailInfoHeaderView.swift
//  MEME
//
//  Created by 이동현 on 4/14/24.
//

import UIKit
import SnapKit

final class ModelDetailInfoHeaderView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 16)
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
    
    private func initialize() {
        addSubviews()
        makeConstraints()
    }
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - layout configuration
extension ModelDetailInfoHeaderView {
    private func addSubviews() {
        addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(15)
        }
    }
}
