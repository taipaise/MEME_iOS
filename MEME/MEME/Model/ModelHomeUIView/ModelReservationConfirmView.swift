//
//  ModelReservationConfirmView.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import UIKit

// MARK: - ModelReservationConfirmView Interface
class ModelReservationConfirmView: UIView {
    
    @IBOutlet weak var modelReservationDateLabel: UILabel!
    @IBOutlet weak var modelReservationMakeupNameLabel: UILabel!
    @IBOutlet weak var modelReservationArtistNameLabel: UILabel!
    @IBOutlet weak var modelReservationLocationLabel: UILabel!
    @IBOutlet weak var modelReservationStatusImageView: UIImageView!

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("ModelReservationConfirmView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }

    // MARK: - Configuration
    func configure(with reservation: ModelMyReservation) {
        // 날짜 형식
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
                
        if let date = dateFormatter.date(from: reservation.date),
                   let time = timeFormatter.date(from: reservation.time) {
                    
                    var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
                    let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                    dateComponents.hour = timeComponents.hour
                    dateComponents.minute = timeComponents.minute
                    
                    if let combinedDate = Calendar.current.date(from: dateComponents) {
                        let currentDate = Date()
                        
                        if currentDate > combinedDate {
                            modelReservationStatusImageView.image = UIImage(named: "complete_CheckMark")
                            self.backgroundColor = UIColor(red: 244, green: 246, blue: 248, alpha: 1)
                        } else {
                            modelReservationStatusImageView.image = UIImage(systemName: "clock.fill")
                            self.backgroundColor = UIColor(red: 252, green: 227, blue: 213, alpha: 1)
                        }
                    }
                }
        
        modelReservationDateLabel.text = "\(reservation.date) | \(reservation.time)"
        modelReservationMakeupNameLabel.text = reservation.makeupName
        modelReservationArtistNameLabel.text = reservation.artistName
        modelReservationLocationLabel.text = reservation.location
    }
}
