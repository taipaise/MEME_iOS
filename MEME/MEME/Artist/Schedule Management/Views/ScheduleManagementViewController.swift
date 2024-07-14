//
//  ScheduleManagementViewController.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import UIKit
import RxSwift
import RxCocoa

enum TimeType: Int {
    case am
    case pm
    
    var stringValue: String {
        switch self {
        case .am:
            return "오전"
        case .pm:
            return "오후"
        }
    }
}

final class ScheduleManagementViewController: UIViewController {
    typealias TimeCell = ScheduleTimeTableCollectionViewCell
    typealias DataSource = UICollectionViewDiffableDataSource<TimeType, ScheduleTimeTableCellModel.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<TimeType, ScheduleTimeTableCellModel.ID>
    typealias Header = ScheduleHeaderView
    
    @IBOutlet private weak var segmentedControl: ScheduleSegmentedControl!
    @IBOutlet private weak var timeTableContentView: UIView!
    @IBOutlet private weak var myScheduleContentView: UIView!
    @IBOutlet private var dayOfWeekButtons: [UIButton]!
    @IBOutlet private weak var noneButton: UIButton!
    @IBOutlet private weak var timeTableCollectionView: UICollectionView!
    @IBOutlet private weak var scheduleRegisteButton: UIButton!
    private var dataSource: DataSource?
    private var viewModel = ScheduleManagementViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setUI()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if timeTableCollectionView.contentSize.height != .zero {
            timeTableCollectionView.snp.updateConstraints {
                $0.height.equalTo(timeTableCollectionView.contentSize.height)
            }
        }
    }
    
    private func setUI() {
        noneButton.layer.cornerRadius = 8
        noneButton.layer.borderWidth = 1
        noneButton.layer.borderColor = UIColor.gray200.cgColor
        
        dayOfWeekButtons.forEach {
            let height = $0.frame.height
            $0.layer.cornerRadius = height / 2
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.mainBold.cgColor
        }
        
        scheduleRegisteButton.layer.cornerRadius = 10
    }
}

// MARK: - Binding
extension ScheduleManagementViewController {

    private func bindViewModel() {
        let selectDayOfWeekObservable: Observable<Int> = Observable.merge(
            dayOfWeekButtons.map { button in
                button.rx.tap.map { button.tag }
            }
        )
        
        let input = ScheduleManagementViewModel.Input(
            changeSegment: segmentedControl.selectedSegmentObservable,
            selectDayOfWeek: selectDayOfWeekObservable,
            resetSelectedTime: noneButton.rx.tap.asObservable(),
            toggleSelectedTime: timeTableCollectionView.rx.itemSelected.asObservable(),
            reqeustToSaveTimes: scheduleRegisteButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.selectedSegment
            .withUnretained(self)
            .subscribe { (self, type) in
                switch type {
                case .timeTable:
                    self.timeTableContentView.isHidden = false
                    self.myScheduleContentView.isHidden = true
                case .mySchedule:
                    self.timeTableContentView.isHidden = true
                    self.myScheduleContentView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        output.selectedDayOfWeek
            .withUnretained(self)
            .subscribe { (self, dayOfWeek) in
                let index = dayOfWeek.intVal
                
                self.dayOfWeekButtons.forEach {
                    if $0.tag != index {
                        $0.backgroundColor = .white
                        $0.tintColor = .black
                    } else {
                        $0.backgroundColor = .mainBold
                        $0.tintColor = .white
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.isSelectedCellEmpty
            .withUnretained(self)
            .subscribe { (self, isEmpty) in
                if isEmpty {
                    self.noneButton.layer.borderColor = UIColor.mainBold.cgColor
                } else {
                    self.noneButton.layer.borderColor = UIColor.gray400.cgColor
                }
            }
            .disposed(by: disposeBag)
        
        output.cellModelUpdatedType
            .withUnretained(self)
            .subscribe { (self, type) in
                switch type {
                case .initialization:
                    self.applyItems(
                        amCellModels: self.viewModel.amCellModels,
                        pmCellModels: self.viewModel.pmCellModels
                    )
                case .changed:
                    self.reconfigureItems(
                        amCellModels: self.viewModel.amCellModels,
                        pmCellModels: self.viewModel.pmCellModels
                    )
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - collectionView configuration
extension ScheduleManagementViewController {
    private func configureCollectionView() {
        timeTableCollectionView.backgroundColor = .white
        timeTableCollectionView.showsVerticalScrollIndicator = false
        timeTableCollectionView.collectionViewLayout = createCollectionViewLayout()
        timeTableCollectionView.register(
            Header.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Header.className
        )
        timeTableCollectionView.register(cells: [TimeCell.self], usingNib: false)
        
        dataSource = .init(collectionView: timeTableCollectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            let section = indexPath.section
            let cellModels: [ScheduleTimeTableCellModel]?
            if section == TimeType.am.rawValue {
                cellModels = self?.viewModel.amCellModels
            } else {
                cellModels = self?.viewModel.pmCellModels
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCell.className, for: indexPath)
            
            if
                let cellModels = cellModels,
                let cellModel = cellModels[safe: indexPath.row],
                let cell = cell as? TimeCell
            {
                cell.configure(cellModel)
            }
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            let header = self?.timeTableCollectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: Header.className,
                for: indexPath
            ) as? Header
            header?.setTitle(index: indexPath.section)
            return header
        }
    }
    
    private func applyItems(
        amCellModels: [ScheduleTimeTableCellModel],
        pmCellModels: [ScheduleTimeTableCellModel]
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.am, .pm])
        
        let amIdentifiers = amCellModels.map { return $0.id }
        let pmIdentifiers = pmCellModels.map { return $0.id }
        snapshot.appendItems(amIdentifiers, toSection: .am)
        snapshot.appendItems(pmIdentifiers, toSection: .pm)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func reconfigureItems(
        amCellModels: [ScheduleTimeTableCellModel],
        pmCellModels: [ScheduleTimeTableCellModel]
    ) {
        guard let dataSource = dataSource else { return }
        var snapshot = dataSource.snapshot()
        
        let amIdentifiers = amCellModels.map { return $0.id }
        let pmIdentifiers = pmCellModels.map { return $0.id }
        
        snapshot.reconfigureItems(amIdentifiers)
        snapshot.reconfigureItems(pmIdentifiers)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(
                top: 0,
                leading: 2.5,
                bottom: 0,
                trailing: 2.5
            )
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(33)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
            
            group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(0),
                trailing: .fixed(0),
                bottom: .fixed(7)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets =
            NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 10,
                trailing: 0
            )
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(17)
            )
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            sectionHeader.edgeSpacing = .init(
                leading: .fixed(2.5),
                top: .none,
                trailing: .none,
                bottom: .fixed(5)
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        return layout
    }
}

