//
//  ModelReservationConfirmViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import UIKit
import SnapKit

class ModelReservationConfirmViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ModelReservationConfirmViewCell"
    
    @IBOutlet weak var modelReservationDateLabel: UILabel!
    @IBOutlet weak var modelReservationLabel: UILabel!
    @IBOutlet weak var modelReservationMakeupNameLabel: UILabel!
    @IBOutlet weak var modelReservationArtistNameLabel: UILabel!
    @IBOutlet private weak var modelReservationLocationImageView: UIImageView!
    @IBOutlet weak var modelReservationLocationLabel: UILabel!
    @IBOutlet private weak var modelReservationWonLabel: UILabel!
    @IBOutlet weak var modelReservationPriceLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        modelReservationLocationImageView.image = UIImage(named: "icon_location")
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func configure(with data: ReservationData) {
//        let isoFormatter = ISO8601DateFormatter()
//            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//            if let date = isoFormatter.date(from: data.reservationDate) {
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "HH:mm"
//                modelReservationDateLabel.text = timeFormatter.string(from: date)
//            } else {
//                modelReservationDateLabel.text = "날짜 오류"
//            }
        modelReservationDateLabel.text = convertTimeString(data.reservationDayOfWeekAndTime.values.first!)
        modelReservationMakeupNameLabel.text = data.makeupName
        modelReservationArtistNameLabel.text = data.artistNickName
        modelReservationLocationLabel.text = data.shopLocation
        modelReservationPriceLabel.text = "\(data.price)원"
    }
    
}

extension ModelReservationConfirmViewCell {
    func convertTimeString(_ input: String) -> String {
        // 문자열의 처음의 "_"를 ":"로 대체하여 반환
        var result = input
        if let firstUnderscoreIndex = input.firstIndex(of: "_") {
            result.replaceSubrange(firstUnderscoreIndex...firstUnderscoreIndex, with: "")
        }
        return result.replacingOccurrences(of: "_", with: ":")
    }
}
