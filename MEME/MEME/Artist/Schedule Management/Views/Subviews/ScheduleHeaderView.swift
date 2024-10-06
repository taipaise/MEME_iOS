//
//  ScheduleHeaderView.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import UIKit

final class ScheduleHeaderView: UICollectionReusableView {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 14)
        label.textColor = .black
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
    
    func setTitle(index: Int) {
        if index == TimeType.am.rawValue {
            title.text = "오전"
        } else {
            title.text = "오후"
        }
    }
    
    private func setLayout() {
        addSubview(title)
        
        title.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
