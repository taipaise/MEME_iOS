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
        portfolioCollectionView.register(
            UINib(
            nibName: ArtistPortfolioCollectionViewCell.className,
            bundle: nil),
            forCellWithReuseIdentifier: ArtistPortfolioCollectionViewCell.className)

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
        return portfolioData.content!.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArtistPortfolioCollectionViewCell.className,
                for: indexPath
            ) as? ArtistPortfolioCollectionViewCell
            else { return UICollectionViewCell() }
            if let portfolioData = portfolioData {
                cell.portfolioMainLabel.text = portfolioData.content?[indexPath.row].makeupName
                cell.portfolioSubLabel.text = portfolioData.content?[indexPath.row].category
                cell.portfolioPriceLabel.text = String(portfolioData.content![indexPath.row].price) + "원"
                if let url = URL(string: portfolioData.content![indexPath.row].portfolioImgDtoList[0].portfolioImgSrc) {
                    URLSession.shared.dataTask(
                        with: url) {
                            data, response, error in
                            DispatchQueue.main.async {
                                if let data = data, error == nil {
                                    cell.portfolioImageView.image = UIImage(data: data)
                                } else {
                                    cell.portfolioImageView.image = nil
                                }
                        }
                    }.resume()
                } else {
                    cell.portfolioImageView.image = nil
                }
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
        return CGSize(width: 170, height: 250)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
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
