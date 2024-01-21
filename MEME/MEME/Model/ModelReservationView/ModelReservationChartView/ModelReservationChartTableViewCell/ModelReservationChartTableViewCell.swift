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
    
    @IBOutlet weak var makeupImgView: UIImageView!
    @IBOutlet weak var makeupSortView: UIView!
    @IBOutlet weak var makeupSortLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var shopLocationLabel: UILabel!
    @IBOutlet weak var visitView: UIView!
    @IBOutlet weak var visitLabel: UILabel!
    @IBOutlet weak var visitLocationLabel: UILabel!
    
    @IBOutlet weak var makeupNameLabel: UILabel!
    @IBOutlet weak var makeupPriceLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewExplainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shopView.layer.borderColor = UIColor.mainLight.cgColor
        visitView.layer.borderColor = UIColor.mainLight.cgColor

    }

}
