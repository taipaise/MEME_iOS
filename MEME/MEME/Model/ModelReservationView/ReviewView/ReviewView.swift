//
//  ReviewView.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit

class ReviewView: UIView {
    private var totalStarRatingView = TotalStarRatingView()
    private var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray200
        
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let sampleData = StarRatingDistribution(fiveStars: 50, fourStars: 30, threeStars: 15, twoStars: 3, oneStar: 2)
                
        totalStarRatingView.update(with: sampleData)
        
        configureSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
        makeConstraints()
    }
    private func configureSubviews() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalStarRatingView)
        addSubview(lineView)
    }
    private func makeConstraints() {
        totalStarRatingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(166)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
