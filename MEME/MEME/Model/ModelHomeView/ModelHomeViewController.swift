//
//  ViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit

final class ModelHomeViewController: UIViewController {
    // MARK: - Properties
    var memeLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "memeLogo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    var alarmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon _bell")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    let searchMakeup: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "원하는 메이크업을 검색해보세요."
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 20
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1).cgColor
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        let textField = searchBar.searchTextField
            textField.backgroundColor = .white
            textField.textColor = .black
        
        if let leftView = textField.leftView as? UIImageView {
                leftView.tintColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1)
            }
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1)]
            textField.attributedPlaceholder = NSAttributedString(string: "원하는 메이크업을 검색해보세요.", attributes: placeholderAttributes)
        searchBar.tintColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1)
        
        return searchBar
    }()

    var modelWelcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "000 님, 환영합니다!"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        
        return label
    }()
    var modelWelcomeGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트와의 약속 놓치지 마세요!"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    var modelReservationCollectionView: UICollectionView!
    var recomandArtistReservationMainLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 아티스트를 선택할 지 모르겠을 때"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    var recomandArtistReservationSubLabel: UILabel = {
        let label = UILabel()
        label.text = "후기가 많은 아티스트를 만나봐요"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    var recomandArtistReservationCollectionView: UICollectionView!
    var recomandHastyReservationMainLabel: UILabel = {
        let label = UILabel()
        label.text = "급하게 메이크업이 필요할 때"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    var recomandHastyReservationSubLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘, 내일 바로 예약 가능한 아티스트를 알아봐요"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    var recomandHastyReservationCollectionView: UICollectionView!
    
    var modelReservations: [ModelReservationModel]? {
        didSet { self.modelReservationCollectionView.reloadData() }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        modelReservationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        setupReservationCollectionView()
        setupMakeupCardCollectionView()
        configureSubviews()
        makeConstraints()
    }
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(memeLogoImageView)
        view.addSubview(alarmImageView)
        view.addSubview(searchMakeup)
        view.addSubview(modelWelcomeLabel)
        view.addSubview(modelWelcomeGuideLabel)
        view.addSubview(modelReservationCollectionView)
        view.addSubview(recomandArtistReservationMainLabel)
        view.addSubview(recomandArtistReservationSubLabel)
        view.addSubview(recomandArtistReservationCollectionView)
        view.addSubview(recomandHastyReservationMainLabel)
        view.addSubview(recomandHastyReservationSubLabel)
        view.addSubview(recomandHastyReservationCollectionView)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        memeLogoImageView.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(42)
            make.width.equalTo(memeLogoImageView.snp.height).multipliedBy(67.0/42.0)
        }
        alarmImageView.snp.makeConstraints {make in
            make.centerY.equalTo(memeLogoImageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(22)
            make.width.equalTo(memeLogoImageView.snp.height).multipliedBy(6.0/7.0)
        }
        searchMakeup.snp.makeConstraints {make in
            make.top.equalTo(memeLogoImageView.snp.bottom).offset(27)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(41)
        }
        modelWelcomeLabel.snp.makeConstraints {make in
            make.top.equalTo(searchMakeup.snp.bottom).offset(33)
            make.leading.equalToSuperview().offset(24)
        }
        modelWelcomeGuideLabel.snp.makeConstraints {make in
            make.top.equalTo(modelWelcomeLabel.snp.bottom)
            make.leading.equalToSuperview().offset(24)
        }
        modelReservationCollectionView.snp.makeConstraints {make in
            make.top.equalTo(modelWelcomeLabel.snp.top).offset(71)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(142)
        }
        recomandArtistReservationMainLabel.snp.makeConstraints {make in
            make.top.equalTo(modelReservationCollectionView.snp.bottom).offset(44)
            make.leading.equalToSuperview().offset(24)
        }
        recomandArtistReservationSubLabel.snp.makeConstraints {make in
            make.top.equalTo(recomandArtistReservationMainLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(24)
        }
        recomandArtistReservationCollectionView.snp.makeConstraints {make in
            make.top.equalTo(recomandArtistReservationMainLabel.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(225)
        }
        
    }
    
    //MARK: -Helpers
    private func setupReservationCollectionView() {
        //delegate 연결
        modelReservationCollectionView.delegate = self
        modelReservationCollectionView.dataSource = self
        
        //cell 등록
        modelReservationCollectionView.register(UINib(nibName: "ModelNonReservationViewCell", bundle: nil), forCellWithReuseIdentifier: ModelNonReservationViewCell.identifier)
        
        modelReservationCollectionView.register(UINib(nibName: "ModelReservationConfirmViewCell", bundle: nil), forCellWithReuseIdentifier: ModelReservationConfirmViewCell.identifier)
    }
    //MARK: -Helpers
    private func setupMakeupCardCollectionView() {
        //delegate 연결
        recomandArtistReservationCollectionView.delegate = self
        recomandArtistReservationCollectionView.dataSource = self
        
        //cell 등록
        modelReservationCollectionView.register(UINib(nibName: "SelectMakeupCardViewCell", bundle: nil), forCellWithReuseIdentifier: SelectMakeupCardViewCell.identifier)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ModelHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            //+불러온 예약 데이터의 수 만큼 바꾸기
            return modelReservations?.count ?? 0
        }
    }
    
    //cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelNonReservationViewCell.identifier, for: indexPath) as? ModelNonReservationViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelReservationConfirmViewCell.identifier, for: indexPath) as? ModelReservationConfirmViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            let itemIndex = indexPath.item
            
            if let cellData = self.modelReservations {
                //cell에 데이터를 전달
            }
            return cell
        }
    }
}

extension ModelHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
                width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
}

//MARK: -API 통신 메소드
extension ModelHomeViewController {
    func successUserDataAPI(_ result: ModelUserModel) {
        // 내용 추가하기
    }
}

