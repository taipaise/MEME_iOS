//
//  ArtistReservationStatusTableViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/13/24.
//

import UIKit

class ArtistReservationStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var reservationFrameView: UIView!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var makeUpNameLabel: UILabel!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var reservationTimeLabel: UILabel!
    @IBOutlet weak var reservationPlaceIconImage: UIImageView!
    @IBOutlet weak var reservationPriceIconLabel: UILabel!
    @IBOutlet weak var reservationManageBtn: UIButton!
    @IBOutlet weak var reservationPlaceLabel: UILabel!
    @IBOutlet weak var reservationPriceLabel: UILabel!
    
    static let identifier = "ArtistReservationStatusTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ArtistReservationStatusTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }

    private func setUI() {
        reservationFrameView.layer.cornerRadius = 10
        selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
