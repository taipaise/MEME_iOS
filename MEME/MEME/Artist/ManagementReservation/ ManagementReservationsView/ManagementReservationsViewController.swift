//
//  ModelManagementReservationsViewController.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit
import SnapKit

struct ReservationSection {
    let date: Date
    var reservations: [ReservationData]
}

final class ManagementReservationsViewController: UIViewController {
    private let isModel : Bool = false
    private var isFavoriteArtist : Bool = false
    var modelID: Int = 1
    var artistID: Int = 2
    
    // MARK: - Properties
    private var allReservations: [ReservationData] = []
    private var reservationSections: [ReservationSection] = []
    private var collectionViewItems: [ReservationCollectionViewItem] = []
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private var reservationStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 현황"
        label.textColor = .black
        label.font = .pretendard(to: .bold, size: 20)
        
        return label
    }()
    private var expectedImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ExpectedButton")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    private var completeImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NoCompleteButton")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    private var reservationCollectionView: UICollectionView! {
        didSet {
            reservationCollectionView.showsHorizontalScrollIndicator = false
            reservationCollectionView.showsVerticalScrollIndicator = false
        }
    }
    
    private let navigationBar = NavigationBarView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.delegate = self
        navigationBar.configure(title: "예약 관리", backButtonisHidden: !isModel)
        
        setupReservationCollectionView()
        configureSubviews()
        makeConstraints()
        showReservations()
        setupImageViewGestures()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showReservations()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(topView)
        topView.addSubview(reservationStatusLabel)
        topView.addSubview(expectedImgView)
        topView.addSubview(completeImgView)
        reservationCollectionView.backgroundColor = .white
        view.addSubview(reservationCollectionView)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBar.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        topView.snp.makeConstraints {make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        reservationStatusLabel.snp.makeConstraints {make in
            make.bottom.equalTo(topView.snp.bottom).offset(-6)
            make.leading.equalToSuperview()
        }
        completeImgView.snp.makeConstraints {make in
            make.centerY.equalTo(topView.snp.centerY)
            make.height.equalTo(24)
            make.trailing.equalToSuperview()
        }
        expectedImgView.snp.makeConstraints {make in
            make.centerY.equalTo(topView.snp.centerY)
            make.height.equalTo(24)
            make.trailing.equalTo(completeImgView.snp.leading).offset(-8)
        }
        reservationCollectionView.snp.makeConstraints {make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    //MARK: -Action
    @objc private func expectedImgViewTapped() {
        filterAndDisplayReservations(byStatus: .EXPECTED)
        expectedImgView.image = UIImage(named: "ExpectedButton")
        completeImgView.image = UIImage(named: "NoCompleteButton")
    }

    @objc private func completeImgViewTapped() {
        filterAndDisplayReservations(byStatus: .COMPLETE)
        expectedImgView.image = UIImage(named: "NoExpectedButton")
        completeImgView.image = UIImage(named: "CompleteButton")
    }
        
    private func setupImageViewGestures() {
        let expectedTap = UITapGestureRecognizer(target: self, action: #selector(expectedImgViewTapped))
        expectedImgView.addGestureRecognizer(expectedTap)

        let completeTap = UITapGestureRecognizer(target: self, action: #selector(completeImgViewTapped))
        completeImgView.addGestureRecognizer(completeTap)

        expectedImgViewTapped()
    }
    //MARK: -API 호출
    private func showReservations() {
        if(isModel) {
            if let userIdString = KeyChainManager.read(forkey: .memberId), let userId = Int(userIdString) {
                showModelReservations(modelId: userId)
            }
        }
        else{
            if let userIdString = KeyChainManager.read(forkey: .memberId), let userId = Int(userIdString) {
                showArtistReservations(artistId: userId)
            }
        }
    }
    
    private func filterAndDisplayReservations(byStatus status: ReservationState) {
        let filteredReservations = allReservations.filter { $0.status == status.rawValue }
        groupReservationsByDate(filteredReservations)
    }
    
    private var isoDateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }
    
    private func groupReservationsByDate(_ reservations: [ReservationData]) {
        let groupedDictionary = Dictionary(grouping: reservations) { (reservationData) -> Date in
            guard let date = isoDateFormatter.date(from: reservationData.reservationDate) else {
                return Date()
            }
            
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            return Calendar.current.date(from: components) ?? date
        }
        
        reservationSections = groupedDictionary.map { (key, value) in
            ReservationSection(date: key, reservations: value)
        }.sorted(by: { $0.date < $1.date })
        
        setupCollectionViewItems()
    }
    
    //MARK: -Helpers
    enum ReservationCollectionViewItem {
        case date(Date)
        case reservation(ReservationData)
    }
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
    }
    
    private func setupCollectionViewItems() {
        collectionViewItems = reservationSections.flatMap { section -> [ReservationCollectionViewItem] in

            var sectionItems: [ReservationCollectionViewItem] = [.date(section.date)]

            sectionItems += section.reservations.map { .reservation($0) }
            return sectionItems
        }
        reservationCollectionView.reloadData()
    }
    private func setupReservationCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        reservationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        reservationCollectionView.delegate = self
        reservationCollectionView.dataSource = self
        
        //cell 등록
        reservationCollectionView.register(ManagementReservationsDateCollectionViewCell.self, forCellWithReuseIdentifier: ManagementReservationsDateCollectionViewCell.identifier)

  
        reservationCollectionView.register(UINib(nibName: "ModelReservationConfirmViewCell", bundle: nil), forCellWithReuseIdentifier: ModelReservationConfirmViewCell.identifier)
        
    }
}

//MARK: -UITableViewDataSource, UITableViewDelegate
extension ManagementReservationsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewItems.count
    }
    
    //cell의 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionViewItems[indexPath.item]
        switch item {
        case .date(let date):
            guard let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: ManagementReservationsDateCollectionViewCell.identifier, for: indexPath) as? ManagementReservationsDateCollectionViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            dateCell.configure(with: date)
            return dateCell
            
        case .reservation(let reservation):
            guard let reservationCell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelReservationConfirmViewCell.identifier, for: indexPath) as? ModelReservationConfirmViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            if reservation.status == "COMPLETE" {
                reservationCell.modelReservationDateLabel.textColor = .gray500
                reservationCell.modelReservationLocationImageView.image = .iconLocationDisabled
                reservationCell.modelReservationWonLabel.textColor = .gray500
            }else {
                reservationCell.modelReservationDateLabel.textColor = .mainBold
                reservationCell.modelReservationLocationImageView.image = .iconLocation
                reservationCell.modelReservationWonLabel.textColor = .mainBold

            }
            reservationCell.contentView.backgroundColor = .gray200
            reservationCell.modelReservationLabel.textColor = .black
            reservationCell.modelReservationMakeupNameLabel.textColor = .black
            reservationCell.modelReservationArtistNameLabel.textColor = .black
            reservationCell.modelReservationLocationLabel.textColor = .black
            reservationCell.modelReservationPriceLabel.textColor = .black
            reservationCell.configure(with: reservation)
            return reservationCell
        }
    }
}

extension ManagementReservationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionViewItems[indexPath.item] {
        case .date:
            return CGSize(width: collectionView.frame.width, height: 20)
        case .reservation:
            return CGSize(width: collectionView.frame.width, height: 142)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let item = collectionViewItems[indexPath.item]
            switch item {
            case .reservation(let reservationData):
                if isModel{
                    let vc = ModelCancelReservationViewController()
                    vc.reservationId = reservationData.reservationId
                    vc.portfolioId = reservationData.portfolioId
                    vc.reservationDate = reservationData.reservationDate
                    navigationController?.pushViewController(vc, animated: true)
                }else{
                    if reservationData.status == "EXPECTED" {
                        let vc = SingleArtistReservationManageViewController()
                        if formatDateString(op: 1, reservationData.reservationDate) == formatDateString(op: 1, DateFormatter().string(from: Date())) {
                            // 오늘
                            vc.isToday = true
                        }
                        vc.reservationData = reservationData
                        vc.reservationTimeString = convertTimeString(vc.reservationData.reservationDayOfWeekAndTime.values.first!)
                        vc.reservationDateString = formatDateString(op: 3,vc.reservationData.reservationDate)
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
            default:
                break
            }
        }
}

// MARK: -BackButtonTappedDelegate
extension ManagementReservationsViewController: BackButtonTappedDelegate  {
    func backButtonTapped() {
        if let navigationController = self.navigationController {
            self.tabBarController?.tabBar.isHidden = false
            navigationController.popViewController(animated: true)
        }
    }
}

//MARK: -API 통신 메소드
extension ManagementReservationsViewController {
    func showModelReservations(modelId: Int) {
        ReservationManager.shared.getModelReservation(modelId: modelId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservationResponse):
                    self?.allReservations = reservationResponse.data ?? []
                    self?.filterAndDisplayReservations(byStatus: .EXPECTED)
                    print("모델 예약 정보 조회 성공: \(reservationResponse)")
                    
                case .failure(let error):
                    print("모델 예약 정보 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    func showArtistReservations(artistId: Int) {
        ReservationManager.shared.getArtistReservation(artistId: artistId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservationResponse):
                    self?.allReservations = reservationResponse.data ?? []
                    self?.filterAndDisplayReservations(byStatus: .EXPECTED)
                    print("아티스트 예약 정보 조회 성공: \(reservationResponse)")
                    
                case .failure(let error):
                    print("아티스트 예약 정보 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension ManagementReservationsViewController {
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
    private func convertTimeString(_ input: String) -> String {
        // 문자열의 처음의 "_"를 ":"로 대체하여 반환
        var result = input
        if let firstUnderscoreIndex = input.firstIndex(of: "_") {
            result.replaceSubrange(firstUnderscoreIndex...firstUnderscoreIndex, with: "")
        }
        return result.replacingOccurrences(of: "_", with: ":")
    }
}
