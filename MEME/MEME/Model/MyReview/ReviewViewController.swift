//
//  ReviewViewController.swift
//  MEME
//
//  Created by 임아영 on 4/4/24.
//

import UIKit

class ReviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    var dataSource: [String] = []
    var response: MyPageResponse?
    var menuView: UIStackView?
    var starRating: Int?
    var data = [AvailableReviewResponseData]()
    var data2 = [WrittenReviewData]()
    var data3 = [DetailReviewData]()
    var availableReviews: [String: [AvailableReviewResponseData]] = [:]
    var writtenReviews: [String: [WrittenReviewData]] = [:]

    
    private lazy var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.profile
        iv.layer.cornerRadius = 42 / 2
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private lazy var modelLabel = UILabel()
    
    private lazy var nameLabel = UILabel()
    
    private lazy var underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    
    private let segmentedControl: MyPageSegmentedControl = {
        let underbarInfo = UnderbarIndicator(height: 3, barColor: .mainBold, backgroundColor: .gray300)
        let control = MyPageSegmentedControl(items: ["리뷰쓰기", "작성한 리뷰"], underbarInfo: underbarInfo)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        updateSegmentedControlText()
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        
        view.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(68)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(25)
        }
        
        view.addSubview(modelLabel)
        modelLabel.text = "모델"
        modelLabel.font = .pretendard(to: .regular, size: 12)
        modelLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(7)
            make.centerY.equalTo(profileImage.snp.centerY).offset(-10)
        }

        view.addSubview(nameLabel)
        nameLabel.text = "김차차"
        nameLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(5)
            make.centerY.equalTo(profileImage.snp.centerY).offset(10)
        }
        
        view.addSubview(underLineView)
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(22)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.height.equalTo(1)
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(underLineView.snp.bottom).offset(0)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.height.equalTo(46.5)
        }
    }
    
    func configureCollectionView() {
        let layout = CustomFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 37)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: MyReviewCollectionViewCell.className)
        collectionView.register(ReviewDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewDateHeaderView.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10.5)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func updateSegmentedControlText() {
        let buttonText = "리뷰쓰기(\(data.count))"
        segmentedControl.setTitle(buttonText, forSegmentAt: 0)
        let buttonText2 = "작성한 리뷰(\(data2.count))"
        segmentedControl.setTitle(buttonText2, forSegmentAt: 1)
    }
    
//    func ReviewsGroup() {
//        availableReviews = Dictionary(grouping: data, by: { $0.reservationDate })
//        writtenReviews = Dictionary(grouping: data2, by: { $0.createdAt })
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
//            return availableReviews.keys.count
//        case 1:
//            return writtenReviews.keys.count
//        default:
//            return 0
//        }
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
//            let reservationDate = Array(availableReviews.keys)[section]
            return /*availableReviews[reservationDate]?.count ?? 0*/ 1
        case 1:
//            let createdAt = Array(writtenReviews.keys)[section]
            return /*writtenReviews[createdAt]?.count ?? 0*/ 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 37) // 예시 크기
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewCollectionViewCell.className, for: indexPath) as? MyReviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        if segmentedControl.selectedSegmentIndex == 0 {
//            let reservationDate = Array(availableReviews.keys)[indexPath.section]
//            if let review = availableReviews[reservationDate]?[indexPath.row] {
                cell.updateButtonVisibility(isWriteButtonVisible: true)
                let availableReviewData = data[indexPath.row]
                cell.availableconfigure(with: availableReviewData)
//            }
        } else {
//            let createdAt = Array(writtenReviews.keys)[indexPath.section]
//            if let review = writtenReviews[createdAt]?[indexPath.row] {
            cell.updateButtonVisibility(isWriteButtonVisible: false)
            let writtenReviewData = data2[indexPath.row]
            cell.writtenconfigure(with: writtenReviewData)
        }
        cell.backgroundColor = UIColor.gray200
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReviewDateHeaderView.reuseIdentifier, for: indexPath) as? ReviewDateHeaderView else {
            return UICollectionReusableView()
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            headerView.configure(with: "예약일 2000.12.01")
//            데이터 받아올때 아래 코드 사용
//            if indexPath.section < data.count {
//                let sectionData = data[indexPath.section]
//                headerView.configure(with: "예약일 \(sectionData.reservationDate)")
//            }
        } else {
            headerView.configure(with: "작성일 2000.12.02")
//           데이터 받아올때 아래 코드 사용
//            if indexPath.section < data2.count {
//                let sectionData2 = data2[indexPath.section]
//                headerView.configure(with: "작성일 \(sectionData2.createdAt)")
//            }
        }
        
        return headerView
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        updateSegmentedControlText()
        collectionView.reloadData()
    }
    
    func buttonPressed(in cell: UICollectionViewCell) {
        navigationController?.pushViewController(WriteReviewViewController(), animated: true)
    }
    func menubuttonPressed(in cell: UICollectionViewCell, at indexPath: IndexPath) {
        print("menubuttonPressed at \(indexPath)")
        
        //        self.view.viewWithTag(100)?.removeFromSuperview()
        self.menuView?.removeFromSuperview()

        let menuView = UIStackView()
        self.menuView?.removeFromSuperview()
        
        menuView.tag = 100
        menuView.axis = .vertical
        menuView.distribution = .fillEqually
        menuView.backgroundColor = .white
        menuView.layer.cornerRadius = 0
        menuView.layer.borderColor = UIColor.gray300.cgColor
        menuView.layer.borderWidth = 1
        self.view.addSubview(menuView)
        
        let editButton = UIButton()
        editButton.setTitle("수정하기", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.addTarget(self, action: #selector(moveToReviewEditVC), for: .touchUpInside)
        
        let deleteButton = UIButton()
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteCollectionViewCell), for: .touchUpInside)
        deleteButton.tag = indexPath.row // 버튼의 태그에 인덱스 저장
        
        editButton.titleLabel?.font = UIFont.pretendard(to: .regular, size: 12)
        deleteButton.titleLabel?.font = UIFont.pretendard(to: .regular, size: 12)
        
        menuView.addArrangedSubview(editButton)
        menuView.addArrangedSubview(deleteButton)
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        let cellBottomRight = CGPoint(x: cell.bounds.width, y: cell.bounds.height)
        let cellPositionInSuperview = cell.convert(cellBottomRight, to: self.view)
        
        NSLayoutConstraint.activate([
            menuView.rightAnchor.constraint(equalTo: self.view.leftAnchor, constant: cellPositionInSuperview.x - 10),
            menuView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: cellPositionInSuperview.y - 30),
            menuView.widthAnchor.constraint(equalToConstant: 85),
            menuView.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideMenu(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapOutsideMenu(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        // 탭한 위치가 menuView의 frame 밖이면 메뉴를 숨김
        if let menuView = self.menuView, !menuView.frame.contains(location) {
            menuView.isHidden = true
        }

    }
    
    @objc func moveToReviewEditVC() {
        let writeReviewVC = WriteReviewViewController()
        self.navigationController?.pushViewController(writeReviewVC, animated: true)

//        DetailReviewManager.shared.getDetailReview(
//            reviewId: 1,
//            artistNickName: "String",
//            makeupName: "String",
//            star: 3,
//            comment: "String",
//            reviewImgDtoList: [DetailReviewImage]()) { [weak self] result in
//                switch result {
//                case .success(let response):
//                    if let responseData = response.data {
//                        DispatchQueue.main.async {
//                            writeReviewVC.reviewLabel.text = responseData.makeupName
//                            writeReviewVC.reviewTextView.text = responseData.comment
//                            writeReviewVC.updateReviewLabel(artistName: responseData.artistNickName, makeupName: responseData.makeupName)
//                            writeReviewVC.starRatingView = StarRatingView()
//                            writeReviewVC.starRatingView.setStarsRating(rating: responseData.star)
//                            print(responseData.star)
//
//                            if let imageUrl = URL(string: responseData.reviewImgDtoList.first?.reviewImgSrc ?? "") {
//                                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
//                                    DispatchQueue.main.async {
//                                        if let data = data {
//                                            writeReviewVC.imageView.image = UIImage(data: data)
//                                        } else {
//                                            writeReviewVC.imageView.image = UIImage(named: "defaultImage")
//                                        }
//                                        self?.navigationController?.pushViewController(writeReviewVC, animated: true)
//                                    }
//                                }.resume()
//                            } else {
//                                self?.navigationController?.pushViewController(writeReviewVC, animated: true)
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    print("Failure: \(error)")
//                    DispatchQueue.main.async {
//                        self?.navigationController?.pushViewController(writeReviewVC, animated: true)
//                    }
//                }
//        }
    }
    
    @objc func deleteCollectionViewCell(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "삭제", message: "리뷰를 삭제하시겠습니까? (삭제한 리뷰는 복구할 수 없습니다.)", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "예", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            let index = sender.tag
            let modelId = /*KeyChainManager.loadMemberID()*/1
            
            let reviewId = sender.tag
            DeleteReviewManager.shared.deleteReview(modelId: 1, reviewId: 2) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.collectionView.reloadData()
                    case .failure(let error):
                        print("리뷰 삭제 실패: \(error)")
                    }
                }
            }
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
        
        let index = sender.tag

        if dataSource.indices.contains(index) {
            dataSource.remove(at: index)
        } else {
            print("Invalid index")
        }
    }
}

extension ReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        let cellHeight: CGFloat = 88
        
        return CGSize(width: collectionViewSize, height: cellHeight)
    }
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    let padding: CGFloat = 50

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                layoutAttribute.frame.origin.x += padding / 2
            }
        }
        return attributes
    }
}

extension ReviewViewController {
    func getMyPageProfile() {
        MyPageManager.shared.getMyPageProfile(userId: KeyChainManager.loadMemberID()) { [weak self] result in
            switch result {
            case .success(let response):
                self?.response = response
                
                DispatchQueue.main.async {
                    self?.nameLabel.text = response.data?.name
                    if let profileImgUrl = response.data?.profileImg {
                        self?.profileImage.loadImage(from: profileImgUrl)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func getAvailableReview() {
        AvailableReviewManager.shared.getAvailableReview(modelId: KeyChainManager.loadMemberID(), reservationId: 1, portfolioId: 1, artistNickName: "artistNickName", makeupName: "makeupName", reservationDate: "reservationDate", portfolioImg: "portfolioImg", shopLocation: "shopLocation") { [weak self] result in
            switch result {
            case .success(let response):
                if let responseData = response.data {
                    self?.data = responseData
                } else {
                    self?.data = []
                }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.updateSegmentedControlText()
                }
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
    func getWrittenReview() {
        WrittenReviewManager.shared.getWrittenReview(
            modelId: KeyChainManager.loadMemberID(),
            reviewId: 1,
            artistNickName: "artistNickName",
            makeupName: "makeupName",
            portfolioImg: "portfolioImg",
            location: "location",
            createdAt: "createdAt"
        ) { [weak self] result in
            switch result {
            case .success(let response):
                if let responseData = response.data {
                    self?.data2 = responseData

                    self?.updateSegmentedControlText()
                } else {
                    self?.data2 = []
                }
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
}
