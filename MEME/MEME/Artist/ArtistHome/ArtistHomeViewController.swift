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
    @IBOutlet weak var secondArtistResLabel: UILabel!
    @IBOutlet weak var secondArtistResTimeLabel: UILabel!
    
    //Properties
    private var cellCount: Int = 0
    private var artistId: Int = 2
    private var todayCount: Int = 0
    private var tomorrowCount: Int = 0
    private var fromTomorrowCount: Int = 0
    private var showDataCount: Int = 0
    private var selectedIdx: Int!
    private var reservationData: [ReservationData]!
    private var artistProfileData: ArtistProfileData?
    private var reservationStatusData: [Int] = []
    private var showReservationData: [Int] = [0,0,0,0]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getArtistProfile(userId: 1, artistId: artistId)
        getArtistReservation(artistId: artistId)
    }
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
    }
    private func uiSet(){
        print("todayCount:\(todayCount)")
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if(todayCount == 0){
            firstArtistResLabel.text = "포트폴리오 관리하러 가기"
            firstArtistResBtnLabel.text = ">"
            firstArtistResTimeLabel.text = nil
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }else if(todayCount == 1){
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
        if let nickname = artistProfileData?.nickname {
            artistHomeProfileLabel.text = "안녕하세요, \(nickname)님!\n내일 예약 \(String(self.tomorrowCount))건이 있어요."
        }
        if let profileImg = artistProfileData?.profileImg {
//            FirebaseStorageManager.downloadImage(urlString: profileImg) { [weak self] image in
//                guard let image = image else { return } // 성공적으로 업로드 했으면 이미지가 nil 값이 아님
//                //이미지를 가지고 할 작업 처리 ex) 이미지 뷰에 다운 받은 이미지를 넣음
//                self?.artistProfileImageView.image = image
//            }
        }
        if todayCount == 1 {
            
        }
        
    }
    
    private func tableViewConfigure(){
        self.cellCount = 0
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
            print("reservationData.count : \(reservationData.count)")
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
                    print("kor date : \(resTime)")
                    print("now kor : \(koreanTime)")
                    
                    if String(Int(resTime)!) == koreanTime {
                        reservationStatusData.append(0)
                        if(todayCount<2){
                            showReservationData[todayCount] = i
                        }
                        todayCount += 1
                        print("Today\n")
                    }else if String(Int(resTime)!-1) == koreanTime{
                        tomorrowCount += 1
                        reservationStatusData.append(1)
                        if(fromTomorrowCount<2){
                            showReservationData[fromTomorrowCount+2] = i
                        }
                        fromTomorrowCount += 1
                        print("Tomorrow\n")
                    }else if Int(resTime)! > Int(koreanTime)!{
                        reservationStatusData.append(1)
                        if(fromTomorrowCount<2){
                            showReservationData[fromTomorrowCount+2] = i
                        }
                        fromTomorrowCount += 1
                        print("afterTomorrow\n")
                    }else {
                        reservationStatusData.append(-1)
                        print("past")
                    }
                } else {
                    print("날짜 구별 실패1")
                }
                
            }
        }
    //MARK: - formatDateString()
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
            print("날짜 구별 실패")
            return nil
        }
    }
    private func convertTimeString(_ input: String) -> String {
        // 문자열의 처음의 "_"를 ":"로 대체하여 반환
        var result = input
        if let firstUnderscoreIndex = input.firstIndex(of: "_") {
            result.replaceSubrange(firstUnderscoreIndex...firstUnderscoreIndex, with: "")
        }
        return result.replacingOccurrences(of: "_", with: ":")
    }


    
    //MARK: - 아티스트 예약 조회 API
    private func getArtistReservation(artistId: Int){
        let getArtistReservation = ReservationManager.shared
        getArtistReservation.getArtistReservation(artistId: artistId) { result in
            switch result {
            case .success(let response) :
                print("res-success")
                self.todayCount = 0
                self.tomorrowCount = 0
                self.fromTomorrowCount = 0
                self.reservationData = response.data
                self.distinguishDate(reservationData: self.reservationData)
                self.artistReservationStatusTableView.reloadData()
                self.uiSet()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - 아티스트 프로필 조회 API
    func getArtistProfile(userId: Int, artistId: Int) {
        ProfileManager.shared.getArtistProfile(userId: userId, artistId: artistId) { [weak self] result in
            switch result {
            case .success(let response):
                self?.artistProfileData = response.data
                self?.uiSet()
                print("아티스트 프로필 조회 성공: \(self?.artistProfileData?.nickname)")
            case .failure(let error):
                if let responseData = error.response {
                    let responseString = String(data: responseData.data, encoding: .utf8)
                    print("아티스트 프로필 조회 실패: \(responseString ?? "no data")")
                }
            }
        }
    }
    
}
// MARK: - UITableViewDataSource
extension ArtistHomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reservationData = reservationData else {
            return 0
        }
        fromTomorrowCount = 0
        showDataCount = 0
        for i in 0...reservationData.count-1 {
            print("resStatus: \(reservationStatusData[i])")
            self.showDataCount += 1
            if reservationStatusData[i] == 1{
                fromTomorrowCount += 1
                if fromTomorrowCount == 2 {
                    break
                }
            }
        }
        return self.showDataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        cell.makeUpNameLabel.text = reservationData[indexPath.row].makeupName
        cell.modelNameLabel.text = reservationData[indexPath.row].modelNickName
        cell.reservationDateLabel.text = formatDateString(op:1, reservationData[indexPath.row].reservationDate)
        cell.reservationTimeLabel.text = convertTimeString(reservationData[indexPath.row].reservationDayOfWeekAndTime.values.first!)
        cell.reservationPlaceLabel.text = reservationData[indexPath.row].shopLocation
        cell.reservationPriceLabel.text = "\(String(reservationData[indexPath.row].price))원"
        // 버튼 태그로 index 전달
        cell.reservationManageBtn.tag = indexPath.row
        cell.reservationManageBtn.addTarget(self, action: #selector(reservationManagedBtnTapped), for: .touchUpInside)
        return cell
    }
    
}
// MARK: - UITableViewDelegate
extension ArtistHomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if reservationStatusData[indexPath.row] == 1{
            return CGFloat(192)
        }else {
            return CGFloat(0)
        }
    }
}
