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
    @IBOutlet var artistHomeProfileLabel: UILabel!
    
    @IBOutlet var onComingButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var artistReservationStatusTableView: UITableView!
    
    // 더미 데이터
    private var makeUpNameArray : [String] = ["Makeup1","Makeup2","Makeup3"]
    private var modelNameArray : [String] = ["Model1","Model2","Model3"]
    private var reservationDateArray : [String] = ["2024.01.01 월","2024.01.02 화","2024.01.03 수"]
    
    
    // 예약 전적 유무
    private var isReservation : Bool = true
    // 오늘 예약 유무
    private var isTodayReservation : Bool = true
    // 내일 예약 수
    private var tomorrowRes : Int = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISet()
        tableViewConfigure()
    }
    private func UISet(){
        onComingButton.configuration?.imagePadding = CGFloat(8)
        completeButton.configuration?.imagePadding = CGFloat(8)
        
        artistHomeProfileStatusView.layer.cornerRadius = 10
        
        artistProfileImageView.layer.cornerRadius = artistProfileImageView.frame.height/2
        artistProfileImageView.clipsToBounds = true
        
        artistHomeProfileLabel.text = "안녕하세요, 00님!\n내일 예약 " + String(tomorrowRes) + "건이 있어요."
        artistHomeProfileLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        artistHomeProfileLabel.textAlignment = .left
    }
    
    private func tableViewConfigure(){
        artistReservationStatusTableView.delegate = self
        artistReservationStatusTableView.dataSource = self
        artistReservationStatusTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }

    @IBAction func profileImageTapped(_ sender: UIButton) {
        let vc = ArtistProfilePreviewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArtistHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return makeUpNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as! ArtistReservationStatusTableViewCell
        cell.makeUpNameLabel.text = makeUpNameArray[indexPath.row]
        cell.modelNameLabel.text = modelNameArray[indexPath.row]
        cell.reservationDateLabel.text = reservationDateArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(192)
    }
    
    
}
