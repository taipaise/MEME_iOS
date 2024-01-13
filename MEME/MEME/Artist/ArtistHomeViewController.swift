//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

class ArtistHomeViewController: UIViewController {
    @IBOutlet var artistHomeProfileStatusView: UIView!
    @IBOutlet var artistProfileImageView: UIImageView!
    @IBOutlet var ArtistHomeProfileLabel: UILabel!
    
    @IBOutlet var onComingButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var artistReservationStatusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onComingButton.configuration?.imagePadding = CGFloat(8)
        completeButton.configuration?.imagePadding = CGFloat(8)
        
        ArtistHomeProfileLabel.text = "안녕하세요, 00님!\n내일 예약 1건이 있어요."
        ArtistHomeProfileLabel.font = UIFont(name: "Bold", size: 25)
        ArtistHomeProfileLabel.textAlignment = .left
        
    }

}
