//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

class ArtistHomeViewController: UIViewController {
    @IBOutlet var artistHomeProfileStatusView: UIView!
    @IBOutlet var secondArtistHomeProfileStatusView: UIView!
    @IBOutlet var artistHomeProfileNoStatusView: UIView!
    @IBOutlet var artistProfileImageView: UIImageView!
    @IBOutlet var artistHomeProfileLabel: UILabel!
    
    @IBOutlet var artistReservationStatusTableView: UITableView!
    
    // 더미 데이터
    private var makeUpNameArray : [String] = ["메이크업1","메이크업2","메이크업3"]
    private var modelNameArray : [String] = ["모델1","모델2","모델3"]
    private var reservationDateArray : [String] = ["2024.01.01 월","2024.01.02 화","2024.01.03 수"]
    
    
    // 예약 전적 유무
    private var isReservation : Bool = true
    // 오늘 예약 수
    private var TodayRes : Int = 2
    // 내일 예약 수
    private var tomorrowRes : Int = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
        tableViewConfigure()
    }
    private func uiSet(){
        
        if(TodayRes==0){
            artistHomeProfileNoStatusView.isHidden = false
            artistHomeProfileStatusView.isHidden = true
            secondArtistHomeProfileStatusView.isHidden = true
        }else if(TodayRes==1){
            artistHomeProfileNoStatusView.isHidden = true
            artistHomeProfileStatusView.isHidden = false
            secondArtistHomeProfileStatusView.isHidden = true
        }else{
            artistHomeProfileNoStatusView.isHidden = true
            artistHomeProfileStatusView.isHidden = false
            secondArtistHomeProfileStatusView.isHidden = false
        }
        
        
        
        artistHomeProfileStatusView.layer.cornerRadius = 10
        artistHomeProfileNoStatusView.layer.cornerRadius = 10
        secondArtistHomeProfileStatusView.layer.cornerRadius = 10
        
        artistProfileImageView.layer.cornerRadius = artistProfileImageView.frame.height/2
        artistProfileImageView.clipsToBounds = true
        
        artistHomeProfileLabel.text = "안녕하세요, 00님!\n내일 예약 " + String(tomorrowRes) + "건이 있어요."
    }
    
    private func tableViewConfigure(){
        artistReservationStatusTableView.delegate = self
        artistReservationStatusTableView.dataSource = self
        artistReservationStatusTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }

    @IBAction private func profileImageTapped(_ sender: UIButton) {
        let vc = ArtistProfilePreviewViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func portfolioManageBtnTapped(_ sender: UIButton) {
        // 포트폴리오 관리 화면 전환
        // 테이블뷰를 스택뷰랑 레이아웃 잡기위해, 스택뷰랑 겹쳐서 보이기
        if(TodayRes==0){
            print("mangedBtnTapped")
        }
    }
    @IBAction private func entireReservationBtnTapped(_ sender: UIButton) {
        let vc = EntireArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func reservationManagedBtnTapped(){
        let vc = ArtistReservationSingleManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArtistHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(makeUpNameArray.count>2) {
            return 2
        } else {
            return makeUpNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        cell.makeUpNameLabel.text = makeUpNameArray[indexPath.row]
        cell.modelNameLabel.text = modelNameArray[indexPath.row]
        cell.reservationDateLabel.text = reservationDateArray[indexPath.row]
        cell.reservationManageBtn.addTarget(self, action: #selector(reservationManagedBtnTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(192)
    }
    
    
    
}
