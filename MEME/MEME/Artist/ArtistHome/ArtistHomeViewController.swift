//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

class ArtistHomeViewController: UIViewController {
    //UI Properites
    @IBOutlet private var artistHomeProfileStatusView: UIView!
    @IBOutlet private var secondArtistHomeProfileStatusView: UIView!
    @IBOutlet private var artistProfileImageView: UIImageView!
    @IBOutlet private var artistHomeProfileLabel: UILabel!
    @IBOutlet private var artistReservationStatusTableView: UITableView!
    @IBOutlet weak var firstArtistResLabel: UILabel!
    @IBOutlet weak var firstArtistResTimeLabel: UILabel!
    @IBOutlet weak var firstArtistResBtnLabel: UILabel!
    @IBOutlet weak var secondArtistResBtn: UIButton!
    
    //Properties
    var artistId: Int = 1
    var todayCount: Int = 0
    var tomorrowCount: Int = 0
    var selectedIdx: Int!
    var reservationData: [ReservationData]!
    var reservationStatusData: [Int]!
    var showReservationData: [Int] = [0,0,0,0]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getArtistReservation(artistId: artistId, completion: { result in
            self.artistReservationStatusTableView.reloadData() } )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("count : ",reservationData.count)
        uiSet()
        tableViewConfigure()
    }
    private func uiSet(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if(todayCount == 0){
            firstArtistResLabel.text = "포트폴리오 관리하러 가기"
            firstArtistResBtnLabel.text = ">"
            firstArtistResTimeLabel.text = nil
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }else if(todayCount == 1){
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }
        artistHomeProfileStatusView.layer.cornerRadius = 10
        secondArtistHomeProfileStatusView.layer.cornerRadius = 10
        
        artistProfileImageView.layer.cornerRadius = artistProfileImageView.frame.height/2
        artistProfileImageView.clipsToBounds = true
        
        artistHomeProfileLabel.text = "안녕하세요, 00님!\n내일 예약 " + String(tomorrowCount) + "건이 있어요."
    }
    
    private func tableViewConfigure(){
        artistReservationStatusTableView.delegate = self
        artistReservationStatusTableView.dataSource = self
        artistReservationStatusTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }

    @IBAction private func profileImageTapped(_ sender: UIButton) {
        let vc = ArtistProfileViewController()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func entireReservationBtnTapped(_ sender: UIButton) {
        let vc = ManagementReservationsViewController()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func reservationManagedBtnTapped(_ sender: UIButton){
        let vc = SingleArtistReservationManageViewController()
        let selectedIdx = sender.tag
        print(selectedIdx)
        vc.reservationData = reservationData[self.selectedIdx]
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func firstTodayResBtnDidTap(_ sender: UIButton) {
        if(todayCount != 0) {
            let vc = SingleArtistReservationManageViewController()
            vc.reservationData = reservationData[self.showReservationData[0]]
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ArtistPortfolioManageViewController()
            self.tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func secondTodayResBtnDidTap(_ sender: UIButton) {
        let vc = SingleArtistReservationManageViewController()
        vc.reservationData = reservationData[self.showReservationData[1]]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 예정 예약 중 오늘과 내일 이후 구별
    private func distinguishDate(reservationData: [ReservationData]){
        for i in 0..<reservationData.count {
            let dateString: String = reservationData[i].reservationDate
            let dateFormatter = DateFormatter()
            if let date = dateFormatter.date(from: dateString) {
                let calendar = Calendar.current
                let now = Date()
                let difference = calendar.dateComponents([.day], from: now, to: date)
                if let days = difference.day {
                    if days < 0 {
                        reservationStatusData[i] = -1
                    } else {
                        // 미
                        if calendar.isDateInToday(date) {
                            // 오늘
                            reservationStatusData[i] = 0
                            if(todayCount<2){
                                showReservationData[todayCount] = i
                                todayCount += 1
                            }
                        }else {
                            // 내일 이후
                            reservationStatusData[i] = 1
                            if(tomorrowCount<2){
                                showReservationData[tomorrowCount+2] = i
                                tomorrowCount += 1
                            }
                        }
                    }
                } else {
                    print("날짜 구별 실패")
                }
            } else {
                print("날짜 구별 실패")
            }
            
        }
    }
    
    //MARK: - 아티스트 예약 조회 API
    private func getArtistReservation(artistId: Int, completion: @escaping (Bool) -> Void){
        let getArtistReservation = ReservationManager.shared
        getArtistReservation.getArtistReservation(artistId: artistId) { result in
            switch result {
            case .success(let response) :
                self.reservationData = response.data
                self.distinguishDate(reservationData: self.reservationData)
                self.artistReservationStatusTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension ArtistHomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reservationData = reservationData else {
            return 0
        }
        return reservationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        cell.makeUpNameLabel.text = reservationData[indexPath.row].makeupName
        cell.modelNameLabel.text = reservationData[indexPath.row].modelNickName
        // 날짜 형식 변환 필요
        cell.reservationDateLabel.text = reservationData[indexPath.row].reservationDate
        // 버튼 태그로 index 전달
        cell.reservationManageBtn.tag = indexPath.row
        cell.reservationManageBtn.addTarget(self, action: #selector(reservationManagedBtnTapped), for: .touchUpInside)
        return cell
    }
    
}
extension ArtistHomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if reservationStatusData[indexPath.row] == 1 {
            return CGFloat(192)
        }else {
            return 0
        }
    }
}
