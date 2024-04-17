//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

class ArtistHomeViewController: UIViewController {
    //MARK: - UI Properties
    @IBOutlet private weak var artistHomeProfileStatusView: UIView!
    @IBOutlet private weak var secondArtistHomeProfileStatusView: UIView!
    @IBOutlet private weak var artistProfileImageView: UIImageView!
    @IBOutlet private weak var artistHomeProfileLabel: UILabel!
    @IBOutlet private weak var artistReservationStatusTableView: UITableView!
    @IBOutlet private weak var firstArtistResLabel: UILabel!
    @IBOutlet private weak var firstArtistResTimeLabel: UILabel!
    @IBOutlet private weak var firstArtistResBtnLabel: UILabel!
    @IBOutlet private weak var secondArtistResBtn: UIButton!
    @IBOutlet private weak var secondArtistResLabel: UILabel!
    @IBOutlet private weak var secondArtistResTimeLabel: UILabel!
    
    //MARK: - Properties
    private var todayCount: Int = 0
    private var tomorrowCount: Int = 0
    private var fromTomorrowCount: Int = 0
    private var showDataCount: Int = 0
    private var selectedIdx: Int!
    private var reservationData: [ReservationData]!
    private var artistProfileData: MyPageData?
    private var reservationStatusData: [Int] = []
    private var showReservationData: [Int] = [0,0,0,0]
    
    //MARK: - ViewController 생명 주기
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.todayCount = 0
        self.tomorrowCount = 0
        self.fromTomorrowCount = 0
        artistID = KeyChainManager.loadMemberID()
        getArtistProfile(userId: artistID)
        getArtistReservation(artistId: artistID)

    }
    
    //MARK: - setUI()
    private func setUI(){
        artistReservationStatusTableView.backgroundColor = .white
        if(todayCount == 0){
            firstArtistResLabel.text = "포트폴리오 관리하러 가기"
            firstArtistResBtnLabel.text = ">"
            firstArtistResTimeLabel.text = nil
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }else if(todayCount == 1){
            firstArtistResBtnLabel.text = "예약"
            firstArtistResLabel.text = reservationData[showReservationData[0]].makeupName
            firstArtistResTimeLabel.text = convertTimeString(reservationData[showReservationData[0]].reservationDayOfWeekAndTime.values.first!)
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }else{
            firstArtistResLabel.text = reservationData[showReservationData[0]].makeupName
            firstArtistResTimeLabel.text = convertTimeString(reservationData[showReservationData[0]].reservationDayOfWeekAndTime.values.first!)
            secondArtistResLabel.text = reservationData[showReservationData[1]].makeupName
            secondArtistResTimeLabel.text = convertTimeString(reservationData[showReservationData[1]].reservationDayOfWeekAndTime.values.first!)
        }
        artistHomeProfileStatusView.layer.cornerRadius = 10
        secondArtistHomeProfileStatusView.layer.cornerRadius = 10
        
        artistProfileImageView.layer.cornerRadius = artistProfileImageView.frame.height/2
        artistProfileImageView.clipsToBounds = true
        
    }
    
    //MARK: - tableViewConfigure()
    private func tableViewConfigure(){
        artistReservationStatusTableView.delegate = self
        artistReservationStatusTableView.dataSource = self
        artistReservationStatusTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }
    
    //MARK: - @IBAction
    @IBAction private func profileImageTapped(_ sender: UIButton) {
        let vc = ModelViewArtistProfileViewController()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func entireReservationBtnTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    @objc private func reservationManagedBtnTapped(_ sender: UIButton){
        let vc = SingleArtistReservationManageViewController()
        let selectedIdx = sender.tag
        vc.reservationData = reservationData[selectedIdx]
        vc.isToday = false
        vc.reservationTimeString = convertTimeString(vc.reservationData.reservationDayOfWeekAndTime.values.first!)
        vc.reservationDateString = formatDateString(op: 3,vc.reservationData.reservationDate)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func firstTodayResBtnDidTap(_ sender: UIButton) {
        if(todayCount != 0) {
            let vc = SingleArtistReservationManageViewController()
            vc.reservationData = reservationData[self.showReservationData[0]]
            vc.isToday = true
            vc.reservationTimeString = convertTimeString(vc.reservationData.reservationDayOfWeekAndTime.values.first!)
            vc.reservationDateString = formatDateString(op: 3,vc.reservationData.reservationDate)
            self.tabBarController?.tabBar.isHidden = true
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
        vc.isToday = true
        vc.reservationTimeString = convertTimeString(vc.reservationData.reservationDayOfWeekAndTime.values.first!)
        vc.reservationDateString = formatDateString(op: 3,vc.reservationData.reservationDate)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - distinguishDate()
    private func distinguishDate(reservationData: [ReservationData]){
            for i in 0..<reservationData.count {
                let dateString: String = reservationData[i].reservationDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // input 날짜 형식 설정
                if let date = dateFormatter.date(from: dateString) {
                    
                    let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = koreanTimeZone
                    dateFormatter.dateFormat = "yyyyMMdd"
                    
                    let now = Date()
                    
                    let koreanTime = dateFormatter.string(from: now)
                    let resTime = dateFormatter.string(from: date)
                    if(reservationData[i].status == "CANCEL"){
                        // CANCEL
                        reservationStatusData.append(-1)
                    }else {
                        if String(Int(resTime)!) == koreanTime {
                            // Today
                            reservationStatusData.append(0)
                            if(todayCount<2){
                                showReservationData[todayCount] = i
                            }
                            todayCount += 1
                        }else if String(Int(resTime)!-1) == koreanTime{
                            // Tomorrow
                            tomorrowCount += 1
                            reservationStatusData.append(1)
                            if(fromTomorrowCount<2){
                                showReservationData[fromTomorrowCount+2] = i
                            }
                            fromTomorrowCount += 1
                        }else if Int(resTime)! > Int(koreanTime)!{
                            // afterTomorrow
                            reservationStatusData.append(1)
                            if(fromTomorrowCount<2){
                                showReservationData[fromTomorrowCount+2] = i
                            }
                            fromTomorrowCount += 1
                        }else {
                            // past
                            reservationStatusData.append(-1)
                        }
                    }
                } else {
                }
                
            }
        }
    //MARK: - 날짜 형식 변환
    private func formatDateString(op: Int,_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 입력된 날짜의 형식에 맞게 설정
        
        if let date = dateFormatter.date(from: dateString) {
            // 원하는 형식으로 날짜 문자열을 변환
            let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = koreanTimeZone
            if op==1 {
                dateFormatter.dateFormat = "yyyy. MM. dd EEE"
            }else if op==2{
                dateFormatter.dateFormat = "yyyy. MM. dd EEEE"
            }else{
                dateFormatter.dateFormat = "M월 d일 EEEE"
            }
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    //MARK: - 시간 형식 변환
    private func convertTimeString(_ input: String) -> String {
        // 문자열의 처음의 "_"를 ":"로 대체하여 반환
        var result = input
        if let firstUnderscoreIndex = input.firstIndex(of: "_") {
            result.replaceSubrange(firstUnderscoreIndex...firstUnderscoreIndex, with: "")
        }
        return result.replacingOccurrences(of: "_", with: ":")
    }
    
}
// MARK: - UITableViewDataSource
extension ArtistHomeViewController : UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if let reservationData = reservationData {
            fromTomorrowCount = 0
            showDataCount = 0
            for i in 0..<reservationData.count {
                self.showDataCount += 1
                if reservationStatusData[i] == 1{
                    fromTomorrowCount += 1
                    if fromTomorrowCount == 2 {
                        break
                    }
                }
            }
            return self.showDataCount
        }else {
            return 0
        }
        
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        // 셀 교체 필요
        guard let resCell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        resCell.makeUpNameLabel.text = reservationData[indexPath.row].makeupName
        resCell.modelNameLabel.text = reservationData[indexPath.row].modelNickName
        resCell.reservationDateLabel.text = formatDateString(op:1, reservationData[indexPath.row].reservationDate)
        resCell.reservationTimeLabel.text = convertTimeString(reservationData[indexPath.row].reservationDayOfWeekAndTime.values.first!)
        resCell.reservationPlaceLabel.text = reservationData[indexPath.row].shopLocation
        resCell.reservationPriceLabel.text = "\(String(reservationData[indexPath.row].price))원"
        // 버튼 태그로 index 전달
        resCell.reservationManageBtn.tag = indexPath.row
        resCell.reservationManageBtn.addTarget(
            self,
            action: #selector(reservationManagedBtnTapped),
            for: .touchUpInside
        )
        return resCell
    }
    
}
// MARK: - UITableViewDelegate
extension ArtistHomeViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if reservationStatusData[indexPath.row] == 1{
            return CGFloat(192)
        }else {
            return CGFloat(0)
        }
    }
}

//MARK: - API 호출
extension ArtistHomeViewController {
    
    func getArtistProfile(userId: Int){
        MyPageManager.shared.getMyPageProfile(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                
                print("Success: \(profile)")
                print("message: "+profile.message)
                self.artistProfileData? = profile.data!
                
                guard
                    let data = profile.data,
                    let nickName = data.nickname
                else { return }
                
                if nickName.count > 6 {
                    self.artistHomeProfileLabel.text = "안녕하세요,"+"\n"+"\(nickName)님!"+"\n"+"내일 예약 \(String(self.tomorrowCount))건이 있어요."
                }else{
                    print("nicknamecomplete")
                    artistHomeProfileLabel.text = "안녕하세요, \(nickName)님!"+"\n"+"내일 예약 \(String(self.tomorrowCount))건이 있어요."
                }
                if let profileImg = data.profileImg {
                    FirebaseStorageManager.downloadImage(
                        urlString: profileImg
                    ) { [weak self] image in
                        guard let image = image else { return } // 성공적으로 업로드 했으면 이미지가 nil 값이 아님
                        //이미지를 가지고 할 작업 처리 ex) 이미지 뷰에 다운 받은 이미지를 넣음
                        print("Imagecomplete")
                        self?.artistProfileImageView.image = image
                    }
                }
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
    
    private func getArtistReservation(artistId: Int){
        let getArtistReservation = ReservationManager.shared
        getArtistReservation.getArtistReservation(artistId: artistId) { result in
            switch result {
            case .success(let response) :
                self.reservationData = response.data
                self.distinguishDate(reservationData: self.reservationData)
                self.artistReservationStatusTableView.reloadData()
                self.setUI()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
