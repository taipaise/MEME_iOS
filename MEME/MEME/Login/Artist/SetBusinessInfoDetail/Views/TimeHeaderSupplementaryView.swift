//
//  TimeHeaderSupplementaryView.swift
//  MEME
//
//  Created by 이동현 on 1/29/24.
//

import UIKit
import SnapKit
    
final class TimeHeaderSupplementaryView: UICollectionReusableView {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 14)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setTitle(title: String) {
        self.title.text = title
    }
    
    private func setLayout() {
        addSubview(title)
        
        title.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

