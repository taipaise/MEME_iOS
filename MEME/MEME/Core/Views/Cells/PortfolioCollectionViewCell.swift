//
//  PortfolioCollectionViewCell.swift
//  MEME
//
//  Created by 이동현 on 5/2/24.
//

import UIKit

struct PortfolioCellModel {
    let imageURL: String
    let makeUpCategoty: MakeUpCategory
    let name: String
    let rate: Double
    let artistName: String
    let price: Double
}


final class PortfolioCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray300
        label.font = .pretendard(to: .semiBold, size: 10)
        return label
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 14)
        return label
    }()
    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 10)
        return label
    }()
    private lazy var artistPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .pretendard(to: .bold, size: 8)
        return label
    }()
    private lazy var rateImageView: UIImageView = {
        let view = UIImageView()
        view.image = .icLike
        return view
    }()
    private var cellModel: PortfolioCellModel?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(_ cellModel: PortfolioCellModel) {
        self.cellModel = cellModel
        configureImage()
        categoryLabel.text = cellModel.makeUpCategoty.rawValue
        nameLabel.text = cellModel.name
        rateLabel.text = "\(cellModel.rate)"
        
        let artistName = cellModel.artistName
        let price = getPriceString(price: cellModel.price)
        artistPriceLabel.text = "아티스트 \(artistName)/₩\(price)"
    }
}

extension PortfolioCollectionViewCell {
    private func addSubViews() {
        contentView.addSubViews([
            imageView,
            categoryLabel,
            nameLabel,
            rateImageView,
            rateLabel,
            artistPriceLabel
        ])
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(9.5)
            $0.top.equalTo(imageView.snp.bottom).offset(11)
            $0.height.equalTo(14)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom)
            $0.leading.equalTo(categoryLabel)
            $0.height.equalTo(17)
        }
        
        rateImageView.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(7)
            $0.height.equalTo(10)
            $0.width.equalTo(11)
        }
        
        rateLabel.snp.makeConstraints {
            $0.leading.equalTo(rateImageView.snp.trailing).offset(1.5)
            $0.centerY.equalTo(rateImageView)
        }
        
        artistPriceLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel)
            $0.bottom.equalToSuperview().inset(13)
            $0.height.equalTo(10)
        }
    }
}

extension PortfolioCollectionViewCell {
    private func configureImage() {
        guard let cellModel = cellModel else { return }
        
        FirebaseStorageManager.downloadImage(urlString: cellModel.imageURL) { [weak self] image in
            if let image = image {
                self?.imageView.image = image
            }
        }
    }
    
    private func getPriceString(price: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.maximumFractionDigits = 2
        
        let priceString = numberFormatter.string(from: NSNumber(value: price)) ?? "0"
        return priceString
    }
}
