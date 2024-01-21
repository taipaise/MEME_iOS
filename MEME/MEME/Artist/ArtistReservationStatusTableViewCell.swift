//
//  ArtistReservationStatusTableViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/13/24.
//

import UIKit

class ArtistReservationStatusTableViewCell: UITableViewCell {
    @IBOutlet var reservationFrameView: UIView!
    @IBOutlet var reservationDateLabel: UILabel!
    @IBOutlet var makeUpNameLabel: UILabel!
    @IBOutlet var modelNameLabel: UILabel!
    @IBOutlet var reservationManageBtn: UIButton!
    
    // 예정 완료 구분
    var isComplete : Bool = true
    
    static let identifier = "ArtistReservationStatusTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ArtistReservationStatusTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiSet()
    }

    private func uiSet() {
        
        reservationFrameView.layer.cornerRadius = 10
        reservationFrameView.layer.shadowOpacity = 0.1
        reservationFrameView.layer.shadowRadius = 20
        reservationFrameView.layer.shadowOffset = CGSize(width: 8, height: 8)
        
        selectionStyle = .none

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
