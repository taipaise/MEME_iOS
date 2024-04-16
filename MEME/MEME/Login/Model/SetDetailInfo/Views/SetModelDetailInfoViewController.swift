//
//  SetDetailInfoViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import AuthenticationServices
import RxSwift
import RxCocoa

enum ModelDetailInfoSection: Int, Hashable {
    case gender
    case skin
    case color
    
    var description: String {
        switch self {
        case .gender:
            "성별을 알려주세요."
        case .skin:
            "피부 타입을 알려주세요."
        case .color:
            "퍼스널 컬러를 알려주세요."
        }
    }
}

final class SetModelDetailInfoViewController: UIViewController {
    typealias HeaderView = ModelDetailInfoHeaderView
    typealias DetailCell = ModelDetailInfoCollectionViewCell
    typealias DataSource = UICollectionViewDiffableDataSource<ModelDetailInfoSection, ModelDetailCellModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<ModelDetailInfoSection, ModelDetailCellModel>
    
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var completeButton: UIButton!
    var viewModel: SetModelDetailInfoViewModel?
    private var dataSource: DataSource?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureCollectionView()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionView.contentSize.height != .zero {
            collectionView.snp.updateConstraints {
                $0.height.equalTo(collectionView.contentSize.height)
            }
        }
    }
    
    private func setUI() {
        progressBar.configure(progress: 2)
        completeButton.layer.cornerRadius = 10
        navigationItem.title = "회원가입"
    }
}

// MARK: - Binding
extension SetModelDetailInfoViewController {
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = SetModelDetailInfoViewModel.Input(
            cellTap: collectionView.rx.itemSelected.asObservable(),
            completeTap: completeButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input)
        
        output.cellModels
            .subscribe { [weak self] cellModels in
                self?.applySnapshot(cellModels)
            }
            .disposed(by: disposeBag)
        
        output.navigation
            .subscribe { [weak self] navigationType in
                self?.navigate(type: navigationType)
            }
            .disposed(by: disposeBag)
        
        output.nextButtonState
            .subscribe { [weak self] state in
                self?.completeButton.isEnabled = state
                if state {
                    self?.completeButton.backgroundColor = .mainBold
                } else {
                    self?.completeButton.backgroundColor = .gray300
                }
            }
            .disposed(by: disposeBag)
    }
}
// MARK: - collectionView Configuration
extension SetModelDetailInfoViewController {
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(cells: [DetailCell.self])
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.className)
        
        dataSource = .init(collectionView: collectionView) {
            collectionView, indexPath, cellModel in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailCell.className,
                for: indexPath
            )
            
            if let cell = cell as? DetailCell {
                cell.configure(cellModel)
            }
            
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            let header = self?.collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderView.className,
                for: indexPath
            ) as? HeaderView
            
            var sectionType: ModelDetailInfoSection
            switch indexPath.section {
            case ModelDetailInfoSection.gender.rawValue:
                sectionType = .gender
            case ModelDetailInfoSection.skin.rawValue:
                sectionType = .skin
            default:
                sectionType = .color
            }
            header?.configure(sectionType.description)
            return header
        }
    }

    private func applySnapshot(_ cellModels: [[ModelDetailCellModel]]) {
        var snapShot = SnapShot()
        snapShot.appendSections([.gender, .skin, .color])
        snapShot.appendItems(cellModels[ModelDetailInfoSection.gender.rawValue], toSection: .gender)
        snapShot.appendItems(cellModels[ModelDetailInfoSection.skin.rawValue], toSection: .skin)
        snapShot.appendItems(cellModels[ModelDetailInfoSection.color.rawValue], toSection: .color)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 7)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(63)
            )
    
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 2
            )
            group.edgeSpacing = .init(
                leading: .fixed(0),
                top: .fixed(0),
                trailing: .fixed(0),
                bottom: .fixed(11)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 0, bottom: 25, trailing: 0)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(34)
            )
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        return layout
    }
}

extension SetModelDetailInfoViewController {
    private func navigate(type: SetModelDetailInfoViewModel.NavigationType) {
        let coordinator = SignUpCompletionCoordinator(navigationController: navigationController, roleType: .MODEL)
        switch type {
        case .success:
            coordinator.start(isSuccess: true)
        case .fail:
            coordinator.start(isSuccess: false)
        case .none:
            break
        }
    }
}
