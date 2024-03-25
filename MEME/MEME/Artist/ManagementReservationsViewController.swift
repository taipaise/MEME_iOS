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
        navigationBar.configure(title: "전체 예약 보기")
        
        setupReservationCollectionView()
        configureSubviews()
        makeConstraints()
        showReservations()
        setupImageViewGestures()
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
            showModelReservations(modelId: 1)
        }
        else{
            showArtistReservations(artistId: 1)
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
        print("이거:", reservationSections)
        
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
                let vc = SingleArtistReservationManageViewController()
                vc.reservationData = reservationData
                navigationController?.pushViewController(vc, animated: true)
                
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
        let showArtistReservations = ReservationManager.shared
        showArtistReservations.getArtistReservation(artistId: artistId) { [weak self] result in
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
