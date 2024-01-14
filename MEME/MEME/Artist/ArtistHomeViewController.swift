//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit

class ArtistHomeViewController: UIViewController {
    @IBOutlet var artistHomeProfileStatusView: UIView!
    @IBOutlet var artistProfileImageView: UIImageView!
    @IBOutlet var ArtistHomeProfileLabel: UILabel!
    
    @IBOutlet var onComingButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var artistReservationStatusTableView: UITableView!
    
//    let reservationLabel1: UILabel = {
//        let label = UILabel()
//        
//        label.text = "예약된 서비스명"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    let reservationLabel2: UILabel = {
//        let label = UILabel()
//        
//        label.text = "13:00"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    let onComingReservationTimeLabel: UILabel = {
//        let label = UILabel()
//        
//        label.text = "예약"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
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
        
        onComingButton.configuration?.imagePadding = CGFloat(8)
        completeButton.configuration?.imagePadding = CGFloat(8)
        
        artistHomeProfileStatusView.layer.cornerRadius = 10
        
        ArtistHomeProfileLabel.text = "안녕하세요, 00님!\n내일 예약 " + String(tomorrowRes) + "건이 있어요."
        ArtistHomeProfileLabel.font = UIFont(name: "Bold", size: 25)
        ArtistHomeProfileLabel.textAlignment = .left
        
        tableViewConfigure()
        profileImageClickConfigure()
//        addSubView()
    }
    
//    func addSubView(){
//        if(isTodayReservation){
//            artistHomeProfileStatusView.addSubview(reservationLabel1)
//            artistHomeProfileStatusView.addSubview(reservationLabel2)
//            artistHomeProfileStatusView.addSubview(onComingReservationTimeLabel)
//        }else{
//            artistHomeProfileStatusView.addSubview(<#T##view: UIView##UIView#>)
//            artistHomeProfileStatusView.addSubview(<#T##view: UIView##UIView#>)
//        }
//    }
    
    private func tableViewConfigure(){
        artistReservationStatusTableView.delegate = self
        artistReservationStatusTableView.dataSource = self
        artistReservationStatusTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }
    
    private func profileImageClickConfigure(){
        let profileImageBtn = UITapGestureRecognizer(target: self, action: #selector(profileImageClick))
        artistProfileImageView.isUserInteractionEnabled = true
        artistProfileImageView.addGestureRecognizer(profileImageBtn)
    }
    @objc func profileImageClick(sender : UITapGestureRecognizer){
        // 프로필 관리 화면으로 화면 전환
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
