//
//  ReviewDateHeaderView.swift
//  MEME
//
//  Created by 임아영 on 4/4/24.
//

// ReviewDateHeaderView.swift
import UIKit
import SnapKit

class ReviewDateHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "ReviewDateHeaderView"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .medium, size: 14)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}
