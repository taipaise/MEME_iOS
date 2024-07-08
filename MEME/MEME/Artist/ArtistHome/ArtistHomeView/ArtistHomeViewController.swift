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
    private let profileComplete : Bool = false
    private var artistProfileData: ArtistProfileInfoData?
    private var artistReservationData: [ReservationData] = []
    private var artistID: Int = -1
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        artistID = getArtistID()
        profileUISet()
        reservationUISet()
    }
    override func viewWillAppear(_ animated: Bool) {
        getArtistProfile(artistID)
        getArtistReservationData(artistID)
    }
    //MARK: UI Setting functions
    private func profileUISet(){
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
        reservationCollectionView.delegate = self
        reservationCollectionView.dataSource = self
        reservationCollectionView.register(ModelReservationConfirmViewCell.nib, forCellWithReuseIdentifier: ModelReservationConfirmViewCell.className)
        todayReservationCollectionView.delegate = self
        todayReservationCollectionView.dataSource = self
        todayReservationCollectionView.register(ModelReservationConfirmViewCell.nib, forCellWithReuseIdentifier: ModelReservationConfirmViewCell.className)
        todayReservationCollectionView.collectionViewLayout = self.createLayout()
        
    }
    
    // 프로필 완성하러 가기 버튼
    @IBAction func showAllReservationButtonTapped(_ sender: UIButton) {
        //TODO: 화면 전환
    }
}

//MARK: UICollectionViewDelegate
extension ArtistHomeViewController: UICollectionViewDelegate{
    //TODO: 화면 전환
}

//MARK: UICollectionViewDelegate
extension ArtistHomeViewController: UICollectionViewDelegateFlowLayout{
    // todayReservationCollectionView Paging 구현
    private func createModelReservationsSection(using environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self?.createModelReservationsSection(using: layoutEnvironment)
        }, configuration: config)
    }
}

//MARK: UICollectionViewDataSource
extension ArtistHomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case todayReservationCollectionView:
            return dummyReservations.count
        case reservationCollectionView:
            return 0
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
            // todayCell.configure(with: artistReservationData[indexPath.row])
            todayCell.configure(with: dummyReservations[indexPath.row])
            todayCell.backgroundColor = .gray400
            return todayCell
        case reservationCollectionView:
            guard let cell = reservationCollectionView.dequeueReusableCell(withReuseIdentifier: ModelReservationConfirmViewCell.className, for: indexPath) as? ModelReservationConfirmViewCell else {
                return UICollectionViewCell()
            }
            // cell.configure(with: artistReservationData[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
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
                    self.artistReservationData = response.data ?? []
                    self.reservationUISet()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
