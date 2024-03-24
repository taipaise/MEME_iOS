//
//  ShowReviewTableViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/24/24.
//
import UIKit
import SnapKit

class ShowReviewTableViewCell: UITableViewCell {
    private var modelImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "modelProfile"))
        imageView.layer.cornerRadius = 15
        
        return imageView
    }()
    private var modelNameLabel: UILabel = {
        let label = UILabel()
        label.text = "메메**"
        label.font = .pretendard(to: .semiBold, size: 14)
        label.textColor = .black
        
        return label
    }()
    private var starRateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "img_fiveStar"))
        
        return imageView
    }()
    private var reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "후기 작성 칸 후기 작성 칸\n후기후기"
        label.font = .pretendard(to: .regular, size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    private let imagesStackView = UIStackView()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImagesStackView()
        configureSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImagesStackView()
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - Setup
    func setupImagesStackView() {
        imagesStackView.axis = .horizontal
        imagesStackView.spacing = 8
        imagesStackView.distribution = .fill
        imagesStackView.alignment = .fill
        contentView.addSubview(imagesStackView)
    }
    
    // MARK: - configureSubviews
    private func configureSubviews() {
        contentView.addSubview(modelImageView)
        contentView.addSubview(modelNameLabel)
        contentView.addSubview(starRateImageView)
        contentView.addSubview(imagesStackView)
        contentView.addSubview(reviewLabel)
    }
    
    // MARK: - makeConstraints
    private func makeConstraints() {
        modelImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.leading.equalToSuperview()
            make.height.width.equalTo(42)
        }
        modelNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(modelImageView.snp.centerY).offset(-10)
            make.leading.equalTo(modelImageView.snp.trailing).offset(7)
        }
        starRateImageView.snp.makeConstraints { make in
            make.top.equalTo(modelNameLabel.snp.bottom).offset(1)
            make.leading.equalTo(modelImageView.snp.trailing).offset(5)
        }
        imagesStackView.snp.makeConstraints { make in
            make.top.equalTo(modelImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(imagesStackView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-19)
        }
    }
    
    
    func configure(modelName: String, star: Int, comment: String, reviewImgDtoList: [UIImage]) {
        modelNameLabel.text = modelName
        
        switch star {
        case 5:
            starRateImageView.image = UIImage(named: "img_fiveStar")
        case 4:
            starRateImageView.image = UIImage(named: "img_fourStar")
        case 3:
            starRateImageView.image = UIImage(named: "img_threeStar")
        case 2:
            starRateImageView.image = UIImage(named: "img_twoStar")
        case 1:
            starRateImageView.image = UIImage(named: "img_oneStar")
        default:
            starRateImageView.image = UIImage(named: "img_zeroStar")
        }
        
        reviewLabel.text = comment
        
        imagesStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        for reviewImage in reviewImgDtoList {
            let imageView = UIImageView(image: reviewImage)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imagesStackView.addArrangedSubview(imageView)
        }
    }
}

