//
//  InterestArtistCollectionViewCell.swift
//  MEME
//
//  Created by 임아영 on 1/21/24.
//

import UIKit

class InterestArtistCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(named: "Gray300")
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        
        return iv
    }()

       
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        self.backgroundColor = UIColor(named: "Gray100")
        self.layer.cornerRadius = 10
        
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
           imageView.translatesAutoresizingMaskIntoConstraints = false
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           
           addSubview(imageView)
           NSLayoutConstraint.activate([
               imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
               imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
               imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
               imageView.heightAnchor.constraint(equalToConstant: 122)
               ])
           
           addSubview(titleLabel)
           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
               titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
              ])
    }
}
