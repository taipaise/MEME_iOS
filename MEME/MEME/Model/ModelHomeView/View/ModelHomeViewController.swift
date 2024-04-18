//
//  ViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit
import RxSwift

final class ModelHomeViewController: UIViewController {
    // MARK: - UIProperty
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    private let contentsView = UIView()
    private var memeLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .logo
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var alarmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .iconBell
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let searchMakeup: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 20
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.mainBold.cgColor
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = .white
        textField.textColor = .black
        
        if let leftView = textField.leftView as? UIImageView {
            leftView.tintColor = .mainBold
        }
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainBold]
        textField.attributedPlaceholder = NSAttributedString(string: "원하는 메이크업을 검색해보세요.", attributes: placeholderAttributes)
        searchBar.tintColor = .mainBold
        
        return searchBar
    }()
    
    private var modelWelcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "환영합니다!"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 20)
        label.numberOfLines = 0
        
        return label
    }()
    private var modelWelcomeGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트와의 약속 놓치지 마세요!"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 20)
        
        return label
    }()
    private lazy var viewAllReservationsButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 예약 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        if let image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
            button.setImage(image, for: .normal)
        }
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(viewAllReservationsTapped), for: .touchUpInside)
        
        return button
    }()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - Property
    private let disposeBag = DisposeBag()
    private var viewModel = ModelHomeViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<ModelHomeViewControllerSection, ModelHomeViewControllerItem>?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCollectionView()
        addSubViews()
        makeConstraints()
        setupSearchBar()
        bindViewModel()
    }
    
    // MARK: - BindViewModel
    private func bindViewModel() {
        let memberId = KeyChainManager.loadMemberID()
        
        let input = ModelHomeViewModel.Input(
            modelReservationsTrigger: Observable.just(memberId),
            getRecommendArtistByReviewTrigger: .just(()),
            getRecommendArtistByRecentTrigger: .just(()),
            userNicknameTrigger: .just(()))
        
        let output = viewModel.transform(input)
        
        output.userNickname
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] nickname in
                self?.modelWelcomeLabel.text = "\(nickname)님, 환영합니다!"
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.modelReservations,
            output.recommendArtistByReview,
            output.recommendArtistByRecent)
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self]
            modelReservations,
            recommendArtistByReview,
            recommendArtistByRecent in
            self?.setSnapShot(
                modelReservations: modelReservations,
                recommendArtistByReview: recommendArtistByReview,
                recommendArtistByRecent: recommendArtistByRecent)
        }).disposed(by: disposeBag)
    }
    //MARK: -Actions
    func setupSearchBar() {
        searchMakeup.delegate = self
    }
    @objc private func viewAllReservationsTapped() {
        let reservationsVC = ManagementReservationsViewController()
        reservationsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(reservationsVC, animated: true)
    }
}

// MARK: - addSubviews
extension ModelHomeViewController {
    func addSubViews() {
        contentsView.addSubview(memeLogoImageView)
        contentsView.addSubview(alarmImageView)
        contentsView.addSubview(searchMakeup)
        contentsView.addSubview(modelWelcomeLabel)
        contentsView.addSubview(modelWelcomeGuideLabel)
        contentsView.addSubview(viewAllReservationsButton)
        contentsView.addSubview(collectionView)
        scrollView.addSubview(contentsView)
        view.addSubview(scrollView)
    }
}

// MARK: - makeConstraints
extension ModelHomeViewController {
    func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentsView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        memeLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(contentsView.snp.top).offset(10)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.height.equalTo(42)
            make.width.equalTo(memeLogoImageView.snp.height).multipliedBy(67.0/42.0)
        }
        alarmImageView.snp.makeConstraints { make in
            make.centerY.equalTo(memeLogoImageView.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(22)
            make.width.equalTo(memeLogoImageView.snp.height).multipliedBy(6.0/7.0)
        }
        searchMakeup.snp.makeConstraints { make in
            make.top.equalTo(memeLogoImageView.snp.bottom).offset(27)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(41)
        }
        modelWelcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(searchMakeup.snp.bottom).offset(33)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        modelWelcomeGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(modelWelcomeLabel.snp.bottom)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        viewAllReservationsButton.snp.makeConstraints { make in
            make.top.equalTo(modelWelcomeGuideLabel.snp.bottom).offset(17)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(viewAllReservationsButton.snp.bottom).offset(13)
            make.height.equalTo(800)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentsView.snp.bottom)
            
        }
    }
}

//MARK: -CollectionView
extension ModelHomeViewController {
    private func setupCollectionView() {
        collectionView.delegate = self
        
        collectionView.register(ModelNonReservationViewCell.self,
                                forCellWithReuseIdentifier: ModelNonReservationViewCell.identifier)
        collectionView.register(UINib(nibName: ModelReservationConfirmViewCell.className, bundle: nil),
                                forCellWithReuseIdentifier: ModelReservationConfirmViewCell.identifier)
        collectionView.register(UINib(nibName: SelectMakeupCardViewCell.className, bundle: nil),
                                forCellWithReuseIdentifier: SelectMakeupCardViewCell.identifier)
        collectionView.register(UINib(nibName: SelectMakeupCardViewCell.className, bundle: nil),
                                forCellWithReuseIdentifier: SelectMakeupCardViewCell.identifier)
        
        collectionView.register(RecommendHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: RecommendHeaderReusableView.className)
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .white
        setDataSource()
    }
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ModelHomeViewControllerSection, ModelHomeViewControllerItem> (collectionView: collectionView, cellProvider: { collectionView, indexPath, itemidentifier in
            
            switch itemidentifier  {
            case .modelReservations(let reservation):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ModelReservationConfirmViewCell.identifier,
                    for: indexPath) as! ModelReservationConfirmViewCell
                cell.configure(with: reservation)
                return cell
                
                
            case .recommendByReview(let portfolio), .recommendByRecent(let portfolio):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SelectMakeupCardViewCell.identifier,
                    for: indexPath) as? SelectMakeupCardViewCell
                cell?.configure(with: portfolio)
                return cell
                
                
            case .noData:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ModelNonReservationViewCell.identifier,
                    for: indexPath) as! ModelNonReservationViewCell
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            
            guard let sectionType = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
            
            switch sectionType {
            case .recommendByReview:
                if let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RecommendHeaderReusableView.className,
                    for: indexPath) as? RecommendHeaderReusableView {
                    headerView.configure(with: "어떤 아티스트를 선택할 지 모르겠을 때", subText: "후기가 많은 아티스트를 만나봐요")
                    return headerView
                }
            case .recommendByRecent:
                if let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RecommendHeaderReusableView.className,
                    for: indexPath) as? RecommendHeaderReusableView {
                    headerView.configure(with: "새로운 메이크업을 찾아보고 싶을 때", subText: "가장 최근에 올라온 포트폴리오를 알아봐요")
                    return headerView
                }
            default:
                return nil
            }
            return nil
        }
    }
    private func setSnapShot(modelReservations: [ReservationData],
                             recommendArtistByReview: [Portfolio],
                             recommendArtistByRecent: [Portfolio]
    ){
        var snapshot = NSDiffableDataSourceSnapshot<ModelHomeViewControllerSection, ModelHomeViewControllerItem>()
        
        snapshot.appendSections([.modelReservations])
        if modelReservations.isEmpty {
            snapshot.appendItems([.noData("No reservations available")], toSection: .modelReservations)
        } else {
            let modelReservationItems = modelReservations.map(ModelHomeViewControllerItem.modelReservations)
            snapshot.appendItems(modelReservationItems, toSection: .modelReservations)
        }
        
        snapshot.appendSections([.recommendByReview])
        let reviewItems = recommendArtistByReview.map { ModelHomeViewControllerItem.recommendByReview($0) }
        snapshot.appendItems(reviewItems, toSection: .recommendByReview)
        
        snapshot.appendSections([.recommendByRecent])
        let recentItems = recommendArtistByRecent.map { ModelHomeViewControllerItem.recommendByRecent($0) }
        snapshot.appendItems(recentItems, toSection: .recommendByRecent)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = ModelHomeViewControllerSection(rawValue: sectionIndex) else { return nil }
            switch section {
            case .modelReservations:
                return self?.createModelReservationsSection(using: layoutEnvironment)
            case .recommendByReview, .recommendByRecent:
                return self?.createRecommendSection()
            }
        }, configuration: config)
    }
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
    private func createRecommendSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(154), heightDimension: .absolute(222))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(154), heightDimension: .absolute(222))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 24, bottom: 0, trailing: 24)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(48))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        return section
    }
}

//MARK: - UICollectionViewDelegate
extension ModelHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (dataSource?.snapshot().sectionIdentifiers[indexPath.section]) != nil else { return }

        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }

        switch item {
        case .recommendByReview(let portfolio), .recommendByRecent(let portfolio):
            let reservationVC = ModelReservationViewController()
            reservationVC.portfolioID = portfolio.portfolioId
            reservationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(reservationVC, animated: true)

        case .modelReservations(_): break
            
        case .noData: break
            
        }
    }
}


//MARK: - UISearchBarDelegate
extension ModelHomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = ModelSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
        return false
    }
}
