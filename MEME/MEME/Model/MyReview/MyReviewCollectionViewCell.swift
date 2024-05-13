//
//  MyReviewCollectionViewCell.swift
//  MEME
//
//  Created by 임아영 on 2/2/24.
//

import UIKit

protocol MyReviewCollectionViewCellDelegate: AnyObject {
    func buttonPressed(in cell: UICollectionViewCell) 
    func menubuttonPressed(in cell: UICollectionViewCell, at indexPath: IndexPath)
}

class MyReviewCollectionViewCell: UICollectionViewCell {
    weak var delegate: MyReviewCollectionViewCellDelegate?
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
    
    let image = UIImage.moreVertical
         
    lazy var menuButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: .normal)
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(menubuttonPressed(sender:)), for: .touchUpInside)
        
        return btn
    }()
                     
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray200
        self.layer.cornerRadius = 10
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(66)
        }
        
        addSubview(makeupLabel)
        makeupLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(13)
        }

        addSubview(artistLabel)
        artistLabel.snp.makeConstraints { make in
            make.bottom.equalTo(makeupLabel.snp.top).offset(-5)
            make.leading.equalTo(imageView.snp.trailing).offset(13)
        }
        
        addSubview(placeLabel)
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(makeupLabel.snp.bottom).offset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(13)
        }
        
        addSubview(writeButton)
        writeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-14)
            make.width.equalTo(81)
            make.height.equalTo(30)
        }

        
        addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.width.height.equalTo(24)
        }
        printHierarchy(view: self, indent: "")
    }
    func printHierarchy(view: UIView, indent: String) {
        print("\(indent)\(view)")
        for subview in view.subviews {
            printHierarchy(view: subview, indent: indent + "  ")
        }
    }
    func availableconfigure(with reviewData: AvailableReviewResponseData) {
            artistLabel.text = reviewData.artistNickName
            makeupLabel.text = reviewData.makeupName
            placeLabel.text = reviewData.shopLocation
        }
    func writtenconfigure(with reviewData2: WrittenReviewData) {
            artistLabel.text = reviewData2.artistNickName
            makeupLabel.text = reviewData2.makeupName
            placeLabel.text = reviewData2.location
        }
    @objc func buttonPressed() {
            delegate?.buttonPressed(in: self)
        }
    
    @objc func menubuttonPressed(sender:UIButton) {
        if let indexPath = indexPath {
            delegate?.menubuttonPressed(in: self, at: indexPath)
        }
    }
    func updateButtonVisibility(isWriteButtonVisible: Bool) {
        writeButton.isHidden = !isWriteButtonVisible
        menuButton.isHidden = isWriteButtonVisible
    }
}
