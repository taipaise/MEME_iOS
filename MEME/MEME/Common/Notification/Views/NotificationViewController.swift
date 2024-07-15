//
//  NotificationViewController.swift
//  MEME
//
//  Created by 이동현 on 7/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NotificationViewController: UIViewController {
    typealias NotificationCell = NotificationCollectionViewCell
    typealias DataSource = UICollectionViewDiffableDataSource<Int, NotificationCellModel.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, NotificationCellModel.ID>
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var refreshControl = UIRefreshControl()
    private let viewModel = NotificationViewModel()
    private var disposeBag = DisposeBag()
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        configureCollectionView()
        bindViewModel()
    }
}

// MARK: - layout configuration
extension NotificationViewController {
    private func addSubviews() {
        view.addSubViews([
            collectionView
        ])
    }
    private func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

// MARK: - Binding
extension NotificationViewController {
    private func bindViewModel() {
        let input = NotificationViewModel.Input(
            readCell: collectionView.rx.itemSelected.asObservable(),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable()
        )
        let output = viewModel.transform(input)
        
        output.cellModelsUpdatedType
            .withUnretained(self)
            .subscribe { (self, type) in
                switch type {
                case .fetchAll:
                    self.applyItems(cellModels: self.viewModel.cellModels)
                    self.refreshControl.endRefreshing()
                case .readNotification:
                    self.reconfigureItems(cellModels: self.viewModel.cellModels)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - collectionView configuration
extension NotificationViewController {
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(cells: [NotificationCell.self])

        dataSource = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, identifier in
            let cellModels = self?.viewModel.cellModels
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.className, for: indexPath)
            
            if
                let cellModels = cellModels,
                let cell = cell as? NotificationCell
            {
                // TODO: - safe subscript로 수정
                let cellModel = cellModels[indexPath.row]
                cell.configure(cellModel)
            }
            return cell
        }
    }
    
    private func applyItems(cellModels: [NotificationCellModel]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([0])
        let identifiers = cellModels.map { return $0.id }
        snapshot.appendItems(identifiers)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func reconfigureItems(cellModels: [NotificationCellModel]) {
        guard let dataSource = dataSource else { return }
        
        let identifiers = cellModels.map { return $0.id }
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(identifiers)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
        
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(88)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(87)
            )

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}
