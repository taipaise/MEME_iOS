//
//  PortfolioImageCollectionViewCell.swift
//  MEME
//
//  Created by 황채웅 on 7/30/24.
//

import UIKit

protocol PortfolioImageCollectionViewCellDelegate: ArtistPortfolioEditingViewController{
    func deleteButtonTapped()
}

class PortfolioImageCollectionViewCell: UICollectionViewCell {
    private var deleteButton: UIButton{
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }
    private var portfolioImageView: UIImageView{
        let imageView = UIImageView()
        return imageView
    }
    weak var delegate: PortfolioImageCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(deleteButton)
        addSubview(portfolioImageView)
        
        portfolioImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.height.width.equalTo(18)
        }
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton){
        delegate?.deleteButtonTapped()
    }
    
    func configure(image: UIImage){
        portfolioImageView.image = image
    }
}
