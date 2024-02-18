//
//  InfoTableViewCell.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    let infomenuLabel = UILabel()
    let rightLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureUI() {
        
        infomenuLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(infomenuLabel)
    
        infomenuLabel.font = UIFont.pretendard(to: .medium, size: 14)
        
        NSLayoutConstraint.activate([
            infomenuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            infomenuLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24)
        ])
        
        addSubview(rightLabel)
        rightLabel.textAlignment = .right
        rightLabel.font = UIFont.pretendard(to: .regular, size: 14)
        NSLayoutConstraint.activate([
            rightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
      
    }

}

