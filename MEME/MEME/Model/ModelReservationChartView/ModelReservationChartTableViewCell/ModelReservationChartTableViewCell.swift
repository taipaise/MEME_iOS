//
//  ModelReservationChartTableViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/20/24.
//

import UIKit

class ModelReservationChartTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "ModelReservationChartTableViewCell"
    
    @IBOutlet private weak var makeupImgView: UIImageView!
    @IBOutlet private weak var makeupSortView: UIView!
    @IBOutlet private weak var makeupSortLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    
    @IBOutlet private weak var shopView: UIView!
    @IBOutlet private weak var shopLabel: UILabel!
    @IBOutlet private weak var shopLocationLabel: UILabel!
    @IBOutlet private weak var visitView: UIView!
    @IBOutlet private weak var visitLabel: UILabel!
    @IBOutlet private weak var visitLocationLabel: UILabel!
    
    @IBOutlet private weak var makeupNameLabel: UILabel!
    @IBOutlet private weak var makeupPriceLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var reviewLabel: UILabel!
    @IBOutlet private weak var reviewExplainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shopView.backgroundColor = .white
        visitView.backgroundColor = .white
        shopView.layer.borderColor = UIColor.mainLight.cgColor
        visitView.layer.borderColor = UIColor.mainLight.cgColor

    }

}
