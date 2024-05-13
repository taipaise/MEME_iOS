//
//  MyReviewViewController.swift
//  MEME
//
//  Created by 임아영 on 1/29/24.
//

import UIKit
import SnapKit

class MyReviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MyReviewCollectionViewCellDelegate, WrittenCollectionViewCellDelegate {
    
    var collectionView: UICollectionView!
    var dataSource: [String] = []
    var response: MyPageResponse?
    var menuView: UIStackView?
    var starRating: Int?
    var data = [AvailableReviewResponseData]()
    var data2 = [WrittenReviewData]()
    var data3 = [DetailReviewData]()

    
    let ProfileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.profile
        iv.layer.cornerRadius = 42 / 2
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let modelLabel = UILabel()
    
    let nameLabel = UILabel()
    
    let underLineView: UIView = {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 88)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        collectionView.register(ReviewDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewDateHeaderView.reuseIdentifier)

        
        AvailableReviewManager.shared.getAvailableReview(modelId: 1, reservationId: 1, portfolioId: 1, artistNickName: "artistNickName", makeupName: "makeupName", reservationDate: "reservationDate", portfolioImg: "portfolioImg", shopLocation: "shopLocation") { [weak self] result in
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
        
        self.tabBarController?.tabBar.isHidden = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 327, height: 88)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 10.5, left: 0, bottom: 0, right: 0)
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.className)
        collectionView.register(CustomCell2.self, forCellWithReuseIdentifier: CustomCell2.className)
        configureUI()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        segmentedControl.selectedSegmentIndex = 0
        
        MyPageManager.shared.getMyPageProfile(userId: KeyChainManager.loadMemberID()) { [weak self] result in
            switch result {
            case .success(let response):
                self?.response = response
                
                DispatchQueue.main.async {
                    self?.nameLabel.text = response.data?.name
                    if let profileImgUrl = response.data?.profileImg {
                        self?.ProfileImage.loadImage(from: profileImgUrl)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
   
    
    //       self.getAvailableReview(userId: KeyChainManager.loadMemberID())
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        ReviewWrittenView()
        WriteReviewView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func updateSegmentedControlText() {
        let buttonText = "리뷰쓰기(\(data.count))"
        segmentedControl.setTitle(buttonText, forSegmentAt: 0)
        let buttonText2 = "작성한 리뷰(\(data2.count))"
        segmentedControl.setTitle(buttonText2, forSegmentAt: 1)
        
        collectionView.reloadData()
    }
    
    func configureUI() {
        
        navigationItem.title = "나의 리뷰"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)]
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.icBack, for: .normal)
        backButton.configuration?.imagePadding = 25
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        view.backgroundColor = .white
        
        ProfileImage.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ProfileImage)
        NSLayoutConstraint.activate([
            ProfileImage.widthAnchor.constraint(equalToConstant: 42),
            ProfileImage.heightAnchor.constraint(equalToConstant: 42),
            ProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            ProfileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18)
        ])
        
        view.addSubview(modelLabel)
        modelLabel.text = "모델"
        modelLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        NSLayoutConstraint.activate([
            modelLabel.leadingAnchor.constraint(equalTo: ProfileImage.trailingAnchor, constant: 7),
            modelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
        ])
        
        view.addSubview(nameLabel)
        nameLabel.text = "김차차"
        nameLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: ProfileImage.trailingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 3)
        ])
        
        view.addSubview(underLineView)
        underLineView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(22)
            make.leading.equalTo(view.snp.leading).offset(25)
            make.trailing.equalTo(view.snp.trailing).offset(-25)
            make.height.equalTo(1)
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(underLineView.snp.top)
            make.leading.equalTo(view.snp.leading).offset(25)
            make.trailing.equalTo(view.snp.trailing).offset(-25)
            make.height.equalTo(46.5)
        }
        
    }
    
    class CustomCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
        
        weak var delegate: MyReviewCollectionViewCellDelegate?
        var data: AvailableReviewResponseData?
        
        @objc func handleButtonPress() {
            delegate?.buttonPressed(in: self)
        }
        
        let dateLabel: UILabel = {
            let dL = UILabel()
            dL.font = UIFont.pretendard(to: .medium, size: 14)
            dL.text = "예약일 2024. 02. 16 금"
            return dL
        }()
        
        lazy var innerCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: 327, height: 88)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: MyReviewCollectionViewCell.className)
            
            return collectionView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            innerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(dateLabel)
            contentView.addSubview(innerCollectionView)
            
            NSLayoutConstraint.activate([
                dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:33),
                dateLabel.bottomAnchor.constraint(equalTo: innerCollectionView.topAnchor, constant: -5),
                innerCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
                innerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                innerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                innerCollectionView.heightAnchor.constraint(equalToConstant: 88),
                contentView.bottomAnchor.constraint(equalTo: innerCollectionView.bottomAnchor),
            ])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let data = data else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewCollectionViewCell.className, for: indexPath) as! MyReviewCollectionViewCell
            cell.delegate = delegate
//            cell.configure(with: data)
            
            if let imageUrl = URL(string: data.portfolioImg) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                }.resume()
            }
            
            return cell
        }
        
        func setData(_ newdata: AvailableReviewResponseData) {
            self.data = newdata
            self.innerCollectionView.reloadData()
        }
        
        
    }
    
    class CustomCell2: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
        
        weak var delegate: WrittenCollectionViewCellDelegate?
        var indexPath: IndexPath?
        var data2: WrittenReviewData?
        
        //        @objc func handleButtonPress2() {
        //            if let indexPath = indexPath {
        //                delegate?.menubuttonPressed(in: self, at: indexPath)
        //            }
        //        }

        
        let dateLabel: UILabel = {
            let dL = UILabel()
            dL.font = UIFont.pretendard(to: .medium, size: 14)
            dL.text = "작성일 2024. 02. 16 금"
            return dL
        }()
        
        lazy var innerCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: 327, height: 88)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(WrittenCollectionViewCell.self, forCellWithReuseIdentifier: WrittenCollectionViewCell.className)
            return collectionView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            innerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(dateLabel)
            contentView.addSubview(innerCollectionView)
            
            NSLayoutConstraint.activate([
                dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 33),
                dateLabel.bottomAnchor.constraint(equalTo: innerCollectionView.topAnchor, constant: -5),
                innerCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
                innerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                innerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                innerCollectionView.heightAnchor.constraint(equalToConstant: 88),
                contentView.bottomAnchor.constraint(equalTo: innerCollectionView.bottomAnchor),
            ])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            print("Start configuring cell at indexPath \(indexPath)")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WrittenCollectionViewCell.className, for: indexPath) as! WrittenCollectionViewCell
            cell.delegate = delegate
            cell.indexPath = indexPath
            if let unwrappedData2 = data2 {
                cell.configure(with: unwrappedData2)
            }
            
            if let portfolioImgString = data2?.portfolioImg, let imageUrl = URL(string: portfolioImgString) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                }.resume()

            }
            return cell
        }
        func setData2(_ newdata: WrittenReviewData) {
            self.data2 = newdata
            print("Before reloadData on innerCollectionView")
            print("\(Date()) - Before reloadData on innerCollectionView")
            self.innerCollectionView.reloadData()
            print("After reloadData on innerCollectionView")
        }
        
    }
    
    @objc func handleSegmentChange() {
        collectionView.reloadData()
    }
    
    func WriteReviewView() {
        AvailableReviewManager.shared.getAvailableReview(
            modelId: 1,
            reservationId: 3,
            portfolioId: 3,
            artistNickName: "artistNickName",
            makeupName: "makeupName",
            reservationDate: "reservationDate",
            portfolioImg: "portfolioImg",
            shopLocation: "shopLocation"
        ) { [weak self] result in
            switch result {
            case .success(let response):
                if let responseData = response.data {
                    print(response.data)
                    self?.data = responseData
                    self?.updateSegmentedControlText()
                } else {
                    self?.data = []
                }
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
    
    func ReviewWrittenView() {
        WrittenReviewManager.shared.getWrittenReview(
            modelId: 1,
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
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return data.count
        } else {
            return data2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.className, for: indexPath) as! CustomCell
            cell.delegate = self
            if indexPath.row < data.count {
                let reviewData = data[indexPath.row]
                cell.dateLabel.text = "예약일 \(reviewData.reservationDate)"
                cell.setData(reviewData)

            }
            return cell
        case 1:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell2.className, for: indexPath) as? CustomCell2 else { return UICollectionViewCell() }
            cell.delegate = self
            //                        cell.indexPath = indexPath
            if indexPath.row < data2.count {
                let reviewData2 = data2[indexPath.row]
                cell.dateLabel.text = "작성일 \(reviewData2.createdAt)"
                cell.setData2(reviewData2)
                cell.delegate = self

            }
            return cell
        default:
            return UICollectionViewCell()
        }
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

    
//    @objc func moveToReviewEditVC() {
//        let writeReviewVC = WriteReviewViewController()
//        
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        DetailReviewManager.shared.getDetailReview(
//            reviewId: 1,
//            artistNickName: "String",
//            makeupName: "String",
//            star: 4,
//            comment: "String",
//            reviewImgDtoList: [DetailReviewImage]()) { [weak self] result in
//                switch result {
//                case .success(let response):
//                    if let responseData = response.data {
//                        DispatchQueue.main.async {
//                            writeReviewVC.reviewLabel.text = responseData.makeupName
//                            writeReviewVC.updateReviewLabel(artistName: responseData.artistNickName, makeupName: responseData.makeupName)
//                            writeReviewVC.starRatingView.setStarsRating(rating: responseData.star)
//
//                            var firstImageUrlString = responseData.reviewImgDtoList.first?.reviewImgSrc ?? ""
////                            if firstImageUrlString.hasPrefix("s") {
////                                firstImageUrlString = String(firstImageUrlString.dropFirst())
////                            }
////                            FirebaseStorageManager.downloadImage(urlString: firstImageUrlString) { image in
////                                DispatchQueue.main.async {
////                                    if let image = image {
////                                        writeReviewVC.imageView.image = image
////                                    }
////                                    dispatchGroup.leave()
////                                }
////                            }
////                        }
////                        self?.starRating = responseData.star
////                    }
////                    
////                case .failure(let error):
////                    print("Failure: \(error)")
////                    dispatchGroup.leave()
////                }
////            }
////    
////    dispatchGroup.notify(queue: .main) {
////        if let starRating = self.starRating {
////            writeReviewVC.starRatingView.setStarsRating(rating: starRating)
////        }
////        self.navigationController?.pushViewController(writeReviewVC, animated: true)
////
////    }
////}
//
//                        if let imageUrl = URL(string: firstImageUrlString) {
//                            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
//                                guard let data = data, error == nil else {
//                                    return
//                                }
//                                DispatchQueue.main.async {
//                                    writeReviewVC.imageView.image = UIImage(data: data)
//                                    self?.navigationController?.pushViewController(writeReviewVC, animated: true)
//                                }
//                            }.resume()
//                        } else {
//                            self?.navigationController?.pushViewController(writeReviewVC, animated: true)
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("Failure: \(error)")
//            }
//        }
//    }
    
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
                        self.ReviewWrittenView()
                        self.WriteReviewView()
                        // 새로고침
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

class CustomSegmentedControl: UISegmentedControl {
    private var indicatorViews = [UIView]()
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        for _ in items ?? [] {
            let indicatorView = UIView()
            indicatorView.backgroundColor = .gray
            indicatorViews.append(indicatorView)
            addSubview(indicatorView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MyReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 125)
    }
}

