//
//  TotalStarRatingView.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit
import SnapKit

struct StarRatingDistribution {
    var fiveStars: Int
    var fourStars: Int
    var threeStars: Int
    var twoStars: Int
    var oneStar: Int
}

// MARK: - Properties
class TotalStarRatingView: UIView {
    private let fiveStarImageView = UIImageView(image: UIImage(named: "img_fiveStar"))
    private let fourStarImageView = UIImageView(image: UIImage(named: "img_fourStar"))
    private let threeStarImageView = UIImageView(image: UIImage(named: "img_threeStar"))
    private let twoStarImageView = UIImageView(image: UIImage(named: "img_twoStar"))
    private let oneStarImageView = UIImageView(image: UIImage(named: "img_oneStar"))
    
    private let fiveStarProgressView = UIProgressView(progressViewStyle: .default)
    private let fourStarProgressView = UIProgressView(progressViewStyle: .default)
    private let threeStarProgressView = UIProgressView(progressViewStyle: .default)
    private let twoStarProgressView = UIProgressView(progressViewStyle: .default)
    private let oneStarProgressView = UIProgressView(progressViewStyle: .default)
    
    private func createStarNumLabel() -> UILabel {
        let label = UILabel()
        label.text = "0"
        label.font = .pretendard(to: UIFont.PretendardType.semiBold, size: 14)
        label.textColor = .gray500
        return label
    }
    
    private lazy var fiveStarNumLabel: UILabel = createStarNumLabel()
    private lazy var fourStarNumLabel: UILabel = createStarNumLabel()
    private lazy var threeStarNumLabel: UILabel = createStarNumLabel()
    private lazy var twoStarNumLabel: UILabel = createStarNumLabel()
    private lazy var oneStarNumLabel: UILabel = createStarNumLabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        [fiveStarProgressView, fourStarProgressView, threeStarProgressView, twoStarProgressView, oneStarProgressView].forEach {
            $0.trackTintColor = .gray300
            $0.progressTintColor = .mainBold
            addSubview($0)
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.gray300.cgColor
        self.layer.borderWidth = 2
        
        var previousStar: UIImageView?
        
        [fiveStarImageView, fourStarImageView, threeStarImageView, twoStarImageView, oneStarImageView].forEach { star in
            addSubview(star)
            star.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(21)
                make.width.equalTo(star.snp.height).multipliedBy(4.5)
                
                if let previousStar = previousStar {
                    make.top.equalTo(previousStar.snp.bottom).offset(9)
                } else {
                    make.top.equalToSuperview().offset(22)
                }
            }
            previousStar = star
        }
        
        setupStarProgressView(fiveStarProgressView, relatedTo: fiveStarImageView)
        setupStarProgressView(fourStarProgressView, relatedTo: fourStarImageView)
        setupStarProgressView(threeStarProgressView, relatedTo: threeStarImageView)
        setupStarProgressView(twoStarProgressView, relatedTo: twoStarImageView)
        setupStarProgressView(oneStarProgressView, relatedTo: oneStarImageView)
        
        setupStarNumLabel(fiveStarNumLabel, relatedTo: fiveStarProgressView)
        setupStarNumLabel(fourStarNumLabel, relatedTo: fourStarProgressView)
        setupStarNumLabel(threeStarNumLabel, relatedTo: threeStarProgressView)
        setupStarNumLabel(twoStarNumLabel, relatedTo: twoStarProgressView)
        setupStarNumLabel(oneStarNumLabel, relatedTo: oneStarProgressView)
    }
    private func setupStarProgressView(_ progressView: UIProgressView, relatedTo imageView: UIImageView) {
        addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.centerY.equalTo(imageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-54)
        }
    }
    private func setupStarNumLabel(_ label: UILabel, relatedTo progressView: UIProgressView) {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(progressView.snp.centerY)
            make.leading.equalTo(progressView.snp.trailing).offset(11)
        }
    }
    
    // MARK: - Update View
    func update(with distribution: StarRatingDistribution) {
        fiveStarNumLabel.text = "\(distribution.fiveStars)"
        fourStarNumLabel.text = "\(distribution.fourStars)"
        threeStarNumLabel.text = "\(distribution.threeStars)"
        twoStarNumLabel.text = "\(distribution.twoStars)"
        oneStarNumLabel.text = "\(distribution.oneStar)"
        
        let totalRatings = distribution.fiveStars + distribution.fourStars + distribution.threeStars + distribution.twoStars + distribution.oneStar
        guard totalRatings > 0 else { return }
        
        fiveStarProgressView.progress = Float(distribution.fiveStars) / Float(totalRatings)
        fourStarProgressView.progress = Float(distribution.fourStars) / Float(totalRatings)
        threeStarProgressView.progress = Float(distribution.threeStars) / Float(totalRatings)
        twoStarProgressView.progress = Float(distribution.twoStars) / Float(totalRatings)
        oneStarProgressView.progress = Float(distribution.oneStar) / Float(totalRatings)
    }
}
