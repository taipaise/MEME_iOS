//
//  WrittenCollectionViewCell.swift
//  MEME
//
//  Created by 임아영 on 2/3/24.
//

import UIKit

protocol WrittenCollectionViewCellDelegate: AnyObject {
    func menubuttonPressed(in cell: UICollectionViewCell, at indexPath: IndexPath)
    
}

class WrittenCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: WrittenCollectionViewCellDelegate?
    var indexPath: IndexPath?

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.frame
        return iv
        }()
  
    let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트명"
        label.font = UIFont(name: "Pretendard-Regular", size: 10)
        return label
    }()
  
    let makeupLabel: UILabel = {
        let label = UILabel()
        label.text = "메이크업명"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
  
    let placeLabel: UILabel = {
        let label = UILabel()
        label.text = "장소명"
        label.font = UIFont(name: "Pretendard-Regular", size: 10)
        return label
    }()
    
    let image = UIImage.moreVertical
 
    lazy var menubutton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: .normal)
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(menubuttonPressed(sender:)), for: .touchUpInside)
  
        return btn
    }()
         
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray200
        self.layer.cornerRadius = 10
  
        configureUI()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        makeupLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        menubutton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 66),
            imageView.heightAnchor.constraint(equalToConstant: 66)
        ])
        
        addSubview(artistLabel)
        addSubview(makeupLabel)
        addSubview(placeLabel)
        NSLayoutConstraint.activate([
            artistLabel.bottomAnchor.constraint(equalTo: makeupLabel.topAnchor, constant: -5),
            artistLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 13),
            makeupLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            makeupLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 13),
            placeLabel.topAnchor.constraint(equalTo: makeupLabel.bottomAnchor, constant: 5),
            placeLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 13)
        ])
        
        addSubview(menubutton)
        NSLayoutConstraint.activate([
            menubutton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            menubutton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            menubutton.widthAnchor.constraint(equalToConstant: 24),
            menubutton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    func configure(with reviewData2: WrittenReviewData) {
            artistLabel.text = reviewData2.artistNickName
            makeupLabel.text = reviewData2.makeupName
            placeLabel.text = reviewData2.location
        }
    @objc func menubuttonPressed(sender:UIButton) {
        if let indexPath = indexPath {
            delegate?.menubuttonPressed(in: self, at: indexPath)
        }
    }

}
