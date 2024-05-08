//
//  InfoTableViewCell.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit
import SnapKit

class InfoTableViewCell: UITableViewCell {
    
    let infomenuLabel = UILabel() {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(to: .medium, size: 14)
        return label
    }()
    
    let rightLabel = UILabel() {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .pretendard(to: .regular, size: 14)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        
        addSubViews()
        makeConstraints()
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
    
    func addSubViews() {
        addSubview(infomenuLabel)
        addSubview(rightLabel)
    }
    
    func makeConstraints() {
        infomenuLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
    }
}
