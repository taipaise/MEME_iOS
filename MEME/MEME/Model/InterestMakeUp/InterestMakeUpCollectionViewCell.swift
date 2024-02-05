//
//  InterestMakeUpCollectionViewCell.swift
//  MEME
//
//  Created by 임아영 on 1/28/24.
//

import UIKit
import SnapKit

class InterestMakeUpCollectionViewCell: UICollectionViewCell {
    
    var shapes = UIView()
    var shadows = UIView()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(named: "Gray300")
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        
        return iv
    }()

    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 10)
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: "Gray100")
        self.layer.cornerRadius = 10

        // 그림자 설정
        self.layer.shadowColor = UIColor(named: "Gray200")?.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 10

        configureUI()
    }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func configureUI() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(122)
        }
        
        self.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.leading.equalTo(self).offset(16)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(6)
            make.leading.equalTo(self).offset(16)
        }
        
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(self).offset(16)
        }
    }
}
