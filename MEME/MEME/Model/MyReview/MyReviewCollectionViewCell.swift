//
//  MyReviewCollectionViewCell.swift
//  MEME
//
//  Created by 임아영 on 2/2/24.
//

import UIKit

protocol MyReviewCollectionViewCellDelegate: AnyObject {
    func buttonPressed(in cell: UICollectionViewCell) 
}

class MyReviewCollectionViewCell: UICollectionViewCell {
    weak var delegate: MyReviewCollectionViewCellDelegate?
  
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
  
          let writeButton: UIButton = {
              let btn = UIButton()
              btn.setTitle("리뷰쓰기", for: .normal)
              btn.setTitleColor(UIColor.mainBold, for: .normal)
              btn.backgroundColor = UIColor.white
              btn.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
              btn.layer.borderColor = UIColor.mainBold.cgColor
              btn.layer.cornerRadius = 15
              btn.clipsToBounds = false
              btn.layer.borderWidth = 1
              btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
  
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
        writeButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        addSubview(writeButton)
        NSLayoutConstraint.activate([
            writeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            writeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            writeButton.widthAnchor.constraint(equalToConstant: 81),
            writeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func buttonPressed() {
            delegate?.buttonPressed(in: self)
        }
}
