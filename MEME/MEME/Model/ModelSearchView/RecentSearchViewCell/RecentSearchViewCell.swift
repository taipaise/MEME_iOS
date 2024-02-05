//
//  RecentSearchViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import UIKit

protocol RecentSearchViewCellDelegate: AnyObject {
    func didTapSearchWord(keyword: String)
    func didTapDeleteButton(keyword: String)
}


class RecentSearchViewCell: UICollectionViewCell {
    static let identifier = "RecentSearchViewCell"
    @IBOutlet weak var searchWordLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    weak var delegate: RecentSearchViewCellDelegate?
    var keyword: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func setupLayer() {
        self.layer.cornerRadius = 13
        self.layer.borderColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }
    
    func configure(with keyword: String) {
        self.keyword = keyword
        searchWordLabel.text = keyword
        searchWordLabel.gestureRecognizers?.forEach(searchWordLabel.removeGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        searchWordLabel.isUserInteractionEnabled = true
        searchWordLabel.addGestureRecognizer(tapGesture)
    }
    @objc func labelTapped() {
        if let keyword = keyword {
            delegate?.didTapSearchWord(keyword: keyword)
        }
    }
    
    @objc func cancelButtonTapped() {
        if let keyword = searchWordLabel.text {
            delegate?.didTapDeleteButton(keyword: keyword)
        }
    }
}

