//
//  ArtistLocationViewController.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import UIKit

final class ArtistLocationViewController: UIViewController {
    typealias LocationCell = BusinessLocationCollectionViewCell
    typealias DataSource = UICollectionViewDiffableDataSource<Int, BusinessLocationModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, BusinessLocationModel>
    
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nextButton: UIButton!
    private var dataSource: DataSource?
    private var snapShot: SnapShot?
    private var dummies = [
        BusinessLocationModel(name: "전체", count: 10),
        BusinessLocationModel(name: "강남구", count: 10),
        BusinessLocationModel(name: "강동구", count: 10),
        BusinessLocationModel(name: "강북구", count: 10),
        BusinessLocationModel(name: "강서구", count: 10),
        BusinessLocationModel(name: "마포구", count: 10),
        BusinessLocationModel(name: "광진구", count: 10),
        BusinessLocationModel(name: "구로구", count: 10),
        BusinessLocationModel(name: "금천구", count: 10),
        BusinessLocationModel(name: "노원구", count: 10),
        BusinessLocationModel(name: "도봉구", count: 10),
        BusinessLocationModel(name: "동대문구", count: 10),
        BusinessLocationModel(name: "서대문구", count: 10),
        BusinessLocationModel(name: "서초구", count: 10),
        BusinessLocationModel(name: "성동구", count: 10)
    ]
    var response: ArtistProfileResponse?
    var getresponse: ArtistProfileInfoResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArtistProfileInfoManager.shared.getArtistProfileInfo(userId: 10) { [weak self] result in
            switch result {
            case .success(let response):
                print("Success: \(response)")
                self?.getresponse = response
                if let data = response.data {
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                } else {
                    print("data nil")
                }
                
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
        
        setUI()
        configureCollectionView()
        nextButton.layer.cornerRadius = 10
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "프로필 입력")
        progressBar.configure(progress: 1)
        nextButton.layer.cornerRadius = 10
    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        let nextVC = ArtistInfoDetailViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension ArtistLocationViewController {
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        configureDataSource()
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<LocationCell, BusinessLocationModel> { cell, indexPath, itemIdentifier in
            cell.configure(location: itemIdentifier.name)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        snapShot = SnapShot()
        snapShot?.appendSections([0])
        snapShot?.appendItems(dummies, toSection: 0)
        dataSource?.apply(snapShot ?? SnapShot(), animatingDifferences: false)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.33),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(76)
            )
    
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 3
            )
            group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(6),
                trailing: .fixed(0),
                bottom: .fixed(6)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}

extension ArtistLocationViewController: UICollectionViewDelegate {
    private func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistLocationViewController", for: indexPath) as! ArtistLocationCollectionViewCell

        let model = dummies[indexPath.item]
        cell.locationLabel.text = model.name

        if let data = getresponse?.data, data.region.map({ $0.koreanName }).contains(model.name) {
            cell.setColor(isSelected: true)
        } else {
            cell.setColor(isSelected: false)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LocationCell else { return }
        cell.setColor(isSelected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LocationCell else { return }
        cell.contentView.layer.borderColor = UIColor.gray300.cgColor
        cell.setColor(isSelected: false)
    }
}

extension ArtistLocationViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
