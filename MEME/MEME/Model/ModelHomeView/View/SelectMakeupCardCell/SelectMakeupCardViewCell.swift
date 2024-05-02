//
//  SelectMakeupCardViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import UIKit

class SelectMakeupCardViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "SelectMakeupCardViewCell"
    
    @IBOutlet private weak var makeupCardImageView: UIImageView!
    @IBOutlet private weak var artistInformLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
    }
    
    func setupLayer() {
        self.layer.cornerRadius = 10
        
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.1
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.layer.shadowRadius = 10
            self.layer.masksToBounds = false
    }
    
    func configure(with portfolio: Portfolio) {
        guard let url = URL(string: portfolio.portfolioImg) else {
            makeupCardImageView.image = UIImage(named: "SelectMakeupCardIMG")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    self?.makeupCardImageView.image = UIImage(data: data)
                } else {
                    self?.makeupCardImageView.image = UIImage(named: "SelectMakeupCardIMG")
                }
            }
        }.resume()

        switch portfolio.makeupLocation {
            case "SHOP":
                artistInformLabel.text = "샵에 재직 중이에요"
            case "VISIT":
                artistInformLabel.text = "방문해서 진행해요"
            case "BOTH":
                artistInformLabel.text = "둘 다 상관없어요"
            default:
                artistInformLabel.text = "샵 위치 정보가 없어요."
        }
        artistNameLabel.text = portfolio.makeupName
        priceLabel.text = "\(portfolio.price)"
        
    }
    func configure(with portfolio: SimplePortfolioDTO) {
        guard let url = URL(string: portfolio.portfolioImg) else {
                makeupCardImageView.image = UIImage(named: "SelectMakeupCardIMG")
                return
            }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    self?.makeupCardImageView.image = UIImage(data: data)
                } else {
                    self?.makeupCardImageView.image = UIImage(named: "SelectMakeupCardIMG")
                }
            }
        }.resume()

        switch portfolio.makeupLocation {
            case "SHOP":
                artistInformLabel.text = "샵에 재직 중이에요"
            case "VISIT":
                artistInformLabel.text = "방문해서 진행해요"
            case "BOTH":
                artistInformLabel.text = "둘 다 상관없어요"
            default:
                artistInformLabel.text = "샵 위치 정보가 없어요."
        }
        artistNameLabel.text = portfolio.makeupName
        priceLabel.text = "\(portfolio.price)"
        
    }
    
    func configureWithPortfolio(_ portfolio: PortfolioData) {
        if let firstImageURLString = portfolio.portfolioImgDtoList?.first?.portfolioImgSrc, let url = URL(string: firstImageURLString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                DispatchQueue.main.async {
                    if let data = data, error == nil, let image = UIImage(data: data) {
                        self?.makeupCardImageView.image = image
                    } else {
                        self?.makeupCardImageView.image = UIImage(named: "SelectMakeupCardIMG")
                    }
                }
            }.resume()
        } else {
            makeupCardImageView.image = UIImage(named: "SelectMakeupCardIMG")
        }
        
        guard let portfolioType = MakeUpCategory(rawValue: portfolio.category.uppercased()) else {
            artistInformLabel.text = "해당 메이크업 분야 없음"
            return
        }

        switch portfolioType {
        case .DAILY:
            artistInformLabel.text = "데일리 메이크업"
        case .ACTOR:
            artistInformLabel.text = "배우 메이크업"
        case .INTERVIEW:
            artistInformLabel.text = "면접 메이크업"
        case .PARTY:
            artistInformLabel.text = "파티/이벤트 메이크업"
        case .WEDDING:
            artistInformLabel.text = "웨딩 메이크업"
        case .PROSTHETIC:
            artistInformLabel.text = "특수 메이크업"
        case .STUDIO:
            artistInformLabel.text = "스튜디오 메이크업"
        case .ETC:
            artistInformLabel.text = "기타 메이크업"
        }
        
        artistNameLabel.text = portfolio.artistNickName
        priceLabel.text = "\(portfolio.price)원"
    }

}
