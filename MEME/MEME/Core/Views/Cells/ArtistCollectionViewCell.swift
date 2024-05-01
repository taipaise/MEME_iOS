//
//  ArtistCollectionViewCell.swift
//  MEME
//
//  Created by 이동현 on 5/2/24.
//

import UIKit

struct ArtistCellModel {
    let imageURL: String
    let location: String?
    let name: String
    let likeCount: Int
    let email: String?
}


final class ArtistCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private lazy var locationLabel: UILabel = {
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
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 10)
        return label
    }()
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .pretendard(to: .bold, size: 8)
        return label
    }()
    private lazy var likeImageView: UIImageView = {
        let view = UIImageView()
        view.image = .icLike
        return view
    }()
    private var cellModel: ArtistCellModel?
    
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
    
    func configure(_ cellModel: ArtistCellModel) {
        self.cellModel = cellModel
        configureImage()
        locationLabel.text = cellModel.location
        nameLabel.text = cellModel.name
        likeLabel.text = "\(cellModel.likeCount)"
        emailLabel.text = cellModel.email
    }
}

extension ArtistCollectionViewCell {
    private func addSubViews() {
        contentView.addSubViews([
            imageView,
            locationLabel,
            nameLabel,
            likeImageView,
            likeLabel,
            emailLabel
        ])
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        
        locationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(9.5)
            $0.top.equalTo(imageView.snp.bottom).offset(11)
            $0.height.equalTo(14)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom)
            $0.leading.equalTo(locationLabel)
            $0.height.equalTo(17)
        }
        
        likeImageView.snp.makeConstraints {
            $0.leading.equalTo(locationLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(7)
            $0.height.equalTo(9)
            $0.width.equalTo(11)
        }
        
        likeLabel.snp.makeConstraints {
            $0.leading.equalTo(likeImageView.snp.trailing).offset(1.5)
            $0.centerY.equalTo(likeImageView)
        }
        
        emailLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel)
            $0.bottom.equalToSuperview().inset(13)
            $0.height.equalTo(10)
        }
    }
}

extension ArtistCollectionViewCell {
    private func configureImage() {
        guard let cellModel = cellModel else { return }
        
        FirebaseStorageManager.downloadImage(urlString: cellModel.imageURL) { [weak self] image in
            if let image = image {
                self?.imageView.image = image
            }
        }
    }
}
