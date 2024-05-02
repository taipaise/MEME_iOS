//
//  InfoTableViewCell.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit
import SnapKit

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
        
        addSubview(infomenuLabel)
        infomenuLabel.font = .pretendard(to: .medium, size: 14)
        infomenuLabel.textColor = .black
        infomenuLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        addSubview(rightLabel)
        rightLabel.textAlignment = .right
        rightLabel.font = .pretendard(to: .regular, size: 14)
        rightLabel.textColor = .black
        rightLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
    }
}
