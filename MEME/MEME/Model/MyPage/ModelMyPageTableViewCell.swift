//
//  MyPageTableViewCell.swift
//  MEME
//
//  Created by 임아영 on 1/12/24.
//

import UIKit
import SnapKit

class ModelMyPageTableViewCell: UITableViewCell {
        
    let menuLabel = UILabel()
        
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
        
    func configureUI() {
        
        addSubview(menuLabel)
        menuLabel.font = .pretendard(to: .medium, size: 14)
        menuLabel.textColor = .black
        menuLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(24)
        }
    }
}
