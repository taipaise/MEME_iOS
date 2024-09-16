//
//  ArtistPortfolioManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/27/24.
//

import UIKit

class ArtistPortfolioManageViewController: UIViewController {
    //MARK: - UI Properties
    @IBOutlet var portfolioCollectionView: UICollectionView!
    @IBOutlet var noPortfolioLabel: UIStackView!
    @IBOutlet weak var portfolioCountLabel: UILabel!
    
    //MARK: - Properties
    private var portfolioData : PortfolioAllDTO?
    
    //MARK: - ViewController 생명 주기
    override func viewDidLoad() {
        super.viewDidLoad()
        portfolioCollectionView.backgroundColor = .white
        collectionViewConfig()
        getAllPortfolio()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.portfolioCountLabel.text = "총 " + String(portfolioData?.content?.count ?? 0) + "개"
        super.viewWillAppear(true)
        self.navigationItem.title = "포트폴리오 관리"
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - collectionViewConfig()
    private func collectionViewConfig(){
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        portfolioCollectionView.register(PortfolioCollectionViewCell.self, forCellWithReuseIdentifier: PortfolioCollectionViewCell.className)
    }
    @IBAction func portfolioAddButtonDidTap(_ sender: UIButton) {
        portfolioIdx = -1
        let vc = ArtistPortfolioEditingViewController(receivedData: portfolioIdx)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegate
extension ArtistPortfolioManageViewController : UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        portfolioIdx = indexPath.row
        let vc = ArtistPortfolioEditingViewController(
            receivedData: Int((self.portfolioData?.content![portfolioIdx].portfolioId)!)
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension ArtistPortfolioManageViewController : UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int
    {
        guard let portfolioData = portfolioData else {
            self.noPortfolioLabel.isHidden = false
            return 0
        }
        return portfolioData.content?.count ?? 0
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PortfolioCollectionViewCell.className,
            for: indexPath
        ) as? PortfolioCollectionViewCell
        else { return UICollectionViewCell() }
        if let portfolioData = dummyData.content?[indexPath.row] {
            cell.configure(PortfolioCellModel(imageURL: portfolioData.portfolioImgDtoList[0].portfolioImgSrc,
                                              makeUpCategoty: MakeUpCategory(rawValue: portfolioData.category) ?? MakeUpCategory.ACTOR,
                                              name: portfolioData.makeupName,
                                              rate: Double(portfolioData.averageStars) ?? 5.0,
                                              artistName: portfolioData.artistNickName,
                                              price: Double(portfolioData.price)), true)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ArtistPortfolioManageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width-30, height: 232)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

//MARK: - API 호출
extension ArtistPortfolioManageViewController {
    private func getAllPortfolio() {
        let getAllPortfolio = PortfolioManager.shared
        getAllPortfolio.getAllPortfolio(artistId: artistID, page: 0) { [weak self] result in
            switch result{
                case .success(let response):
                    self?.portfolioData = response.data
                    self?.portfolioCollectionView.reloadData()
                    self?.noPortfolioLabel.isHidden = !(self?.portfolioData?.content!.isEmpty)!
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
