//
//  RecommendHeaderReusableView.swift
//  MEME
//
//  Created by 정민지 on 4/9/24.
//

import UIKit
import SnapKit

final class RecommendHeaderReusableView: UICollectionReusableView {    
    private let recomandMainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 20)
        label.text = "어떤 아티스트를 선택할 지 모르겠을 때"
        return label
    }()
    
    private let recomandSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        label.text = "후기가 많은 아티스트를 만나봐요"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        addSubview(recomandMainLabel)
        addSubview(recomandSubLabel)
        
        recomandMainLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        recomandSubLabel.snp.makeConstraints { make in
            make.top.equalTo(recomandMainLabel.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(with mainText: String, subText: String) {
        recomandMainLabel.text = mainText
        recomandSubLabel.text = subText
    }
}
