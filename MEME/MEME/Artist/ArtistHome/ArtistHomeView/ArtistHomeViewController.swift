//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

class ArtistHomeViewController: UIViewController {
    //MARK: UI Properties
    @IBOutlet private weak var artistProfileImageView: UIImageView!
    @IBOutlet private weak var artistHomeProfileLabel: UILabel!
    @IBOutlet private weak var todayReservationCollectionView: UICollectionView!
    @IBOutlet private weak var reservationCollectionView: UICollectionView!
    @IBOutlet weak var noProfileView: UIView!
    @IBOutlet private weak var noProfileLabel: UILabel!
    @IBOutlet weak var profileSettingButton: UIButton!
    
    //MARK: Properties
    private var profileComplete : Bool = false
    private var artistProfileData: ArtistProfileInfoData?
    private var artistID: Int = -1
    private var todayReservationData: [ReservationData] = []
    private var pendingReservationData: [ReservationData] = []
    private var groupedReservations: [String: [ReservationData]] = [:]
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        artistID = getArtistID()
        profileUISet()
        reservationUISet()
//        filterReservations(reservationData: dummyReservations)
    }
    override func viewWillAppear(_ animated: Bool) {
        getArtistProfile(artistID)
        getArtistReservationData(artistID)
    }
    //MARK: UI Setting functions
    private func profileUISet(){
//        profileComplete = artistProfileData?.region != nil && artistProfileData?.shopLocation != nil && artistProfileData?.specialization != nil
        // 프로필 완성하러 가기 뷰
        noProfileView.isHidden = profileComplete
        if profileComplete{
            // 프로필 정보 라벨
            artistHomeProfileLabel.text = "안녕하세요,\n\(artistProfileData?.nickname) 님!\n오늘 예약 \("예약 건수")건이 있어요."
        }else {
            // 프로필 정보 라벨
            artistHomeProfileLabel.text = "안녕하세요,\n\(artistProfileData?.nickname) 님!"
            // 프로필 완성하러 가기 버튼
            profileSettingButton.layer.cornerRadius = 10
            // 라벨 텍스트
            noProfileLabel.text = "프로필을 완성하고\n 모델과의 예약을 잡아보세요!"
        }
    }
    
    private func reservationUISet(){
        todayReservationCollectionView.delegate = self
        todayReservationCollectionView.dataSource = self
        todayReservationCollectionView.register(ModelReservationConfirmViewCell.nib, forCellWithReuseIdentifier: ModelReservationConfirmViewCell.className)
        todayReservationCollectionView.collectionViewLayout = self.createTodayReservationLayout()
        reservationCollectionView.delegate = self
        reservationCollectionView.dataSource = self
        reservationCollectionView.register(ModelReservationConfirmViewCell.nib, forCellWithReuseIdentifier: ModelReservationConfirmViewCell.className)
        reservationCollectionView.register(ReservationHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReservationHeaderView.className)
        reservationCollectionView.collectionViewLayout = self.createReservationLayout()
    }
    
    // 전체 예약 보기 버튼
    @IBAction func showAllReservationButtonTapped(_ sender: UIButton) {
        let nextVC = ManagementReservationsViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 프로필 완성하러 가기 버튼
    @IBAction func profileSettingButtonTapped(_ sender: UIButton) {
        let nextVC = SetBusinessInfoViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 프로필 완성하러 가기 버튼
    @IBAction func notificationButtonTapped(_ sender: UIButton) {
        //        let nextVC = NotificationViewController()
        //        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension ArtistHomeViewController{
    func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd E"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
    }
    
    private func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDateInToday(date)
    }
    
    private func filterReservations(reservationData: [ReservationData]) {
        reservationData.forEach { reservation in
            if let date = dateFromString(reservation.reservationDate) {
                switch reservation.status {
                case ReservationState.EXPECTED.rawValue:
                    if isToday(date) {
                        todayReservationData.append(reservation)
                    }
                case ReservationState.PENDING.rawValue:
                    pendingReservationData.append(reservation)
                    
                    let dateString = self.dateString(from: date)
                    if var reservations = groupedReservations[dateString] {
                        reservations.append(reservation)
                        groupedReservations[dateString] = reservations
                    } else {
                        groupedReservations[dateString] = [reservation]
                    }
                default:
                    break
                }
            }
        }
    }
    
}

//MARK: UICollectionViewDelegate
extension ArtistHomeViewController: UICollectionViewDelegate{
    //TODO: 화면 전환
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == todayReservationCollectionView{
            let nextVC = SingleReservationManageViewController(reservationId: todayReservationData[indexPath.row].reservationId)
            navigationController?.pushViewController(nextVC, animated: true)
        }else {
            let sortedKeys = groupedReservations.keys.sorted()
            let dateKey = sortedKeys[indexPath.section]
            if let reservation = groupedReservations[dateKey]?[indexPath.row] {
                let nextVC = SingleReservationManageViewController(reservationId: reservation.reservationId)
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}

//MARK: UICollectionViewDelegate
extension ArtistHomeViewController: UICollectionViewDelegateFlowLayout{
    // todayReservationCollectionView Paging 구현
    private func createTodayReservationsSection(using environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let width = environment.container.effectiveContentSize.width - 48
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(142)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(142)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        return section
    }
    private func createTodayReservationLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self?.createTodayReservationsSection(using: layoutEnvironment)
        }, configuration: config)
    }
    private func createReservationsSection(using environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let width = environment.container.effectiveContentSize.width
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(142)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .estimated(142)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(19))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createReservationLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self?.createReservationsSection(using: layoutEnvironment)
        }, configuration: config)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 19)
    }
}


//MARK: UICollectionViewDataSource
extension ArtistHomeViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 날짜별로 묶은 데이터.count
        switch collectionView{
        case todayReservationCollectionView:
            return 1
        case reservationCollectionView:
            return groupedReservations.keys.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case todayReservationCollectionView:
            return todayReservationData.count
        case reservationCollectionView:
            let dateKey = Array(groupedReservations.keys)[section]
            return groupedReservations[dateKey]?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case todayReservationCollectionView:
            guard let todayCell = todayReservationCollectionView.dequeueReusableCell(withReuseIdentifier: ModelReservationConfirmViewCell.className, for: indexPath) as? ModelReservationConfirmViewCell else {
                return UICollectionViewCell()
            }
            todayCell.configure(with: todayReservationData[indexPath.row])
            todayCell.backgroundColor = .gray400
            return todayCell
        case reservationCollectionView:
            guard let cell = reservationCollectionView.dequeueReusableCell(withReuseIdentifier: ModelReservationConfirmViewCell.className, for: indexPath) as? ModelReservationConfirmViewCell else {
                return UICollectionViewCell()
            }
            let sortedKeys = groupedReservations.keys.sorted()
            let dateKey = sortedKeys[indexPath.section]
            if let reservation = groupedReservations[dateKey]?[indexPath.row] {
                cell.configure(with: reservation)
                cell.contentView.backgroundColor = .gray300
                cell.modelReservationLabel.text = "예약 대기 중"
                cell.modelReservationLabel.textColor = .black
                cell.modelReservationPriceLabel.textColor = .black
                cell.modelReservationArtistNameLabel.textColor = .black
                cell.modelReservationMakeupNameLabel.textColor = .black
                cell.modelReservationLocationLabel.textColor = .black
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReservationHeaderView.className, for: indexPath) as? ReservationHeaderView else {
                return UICollectionReusableView()
            }
            let dateKey = Array(groupedReservations.keys)[indexPath.section]
            header.configure(with: dateKey)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
}

//MARK: API 호출
extension ArtistHomeViewController{
    private func getArtistID() -> Int{
        return KeyChainManager.loadMemberID()
    }
    
    private func getArtistProfile(_ userId: Int){
        ArtistProfileInfoManager.shared.getArtistProfileInfo(userId: userId) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let response):
                    self.artistProfileData = response.data
                    self.profileUISet()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    private func getArtistReservationData(_ artistId: Int){
        ReservationManager.shared.getArtistReservation(artistId: artistId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let reservationData = response.data{
                        self.filterReservations(reservationData: reservationData)
                        self.reservationUISet()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
