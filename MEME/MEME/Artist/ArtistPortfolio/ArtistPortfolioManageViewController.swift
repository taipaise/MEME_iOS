//
//  ArtistPortfolioManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/27/24.
//

import UIKit

class ArtistPortfolioManageViewController: UIViewController {
    
    @IBOutlet var portfolioCollectionView: UICollectionView!
    @IBOutlet var noPortfolioLabel: UIStackView!
    
    private var portfolioData : PortfolioAllDTO?
    private var artistId: Int = 2
    private var page: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        getAllPortfolio()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfig()
        uiSet()
    }
    
    private func uiSet(){
        self.navigationController?.isNavigationBarHidden = true
    }
    private func collectionViewConfig(){
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        portfolioCollectionView.register(UINib(nibName: ArtistPortfolioCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ArtistPortfolioCollectionViewCell.className)

    }
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    @IBAction func portfolioAddButtonDidTap(_ sender: UIButton) {
        portfolioIdx = -1
        let vc = ArtistPortfolioEditingViewController(receivedData: portfolioIdx)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArtistPortfolioManageViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let portfolioData = portfolioData else {
            self.noPortfolioLabel.isHidden = false
            return 0
        }
        return portfolioData.content!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistPortfolioCollectionViewCell.className, for: indexPath) as? ArtistPortfolioCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        portfolioIdx = indexPath.row
        let vc = ArtistPortfolioEditingViewController(
            receivedData: Int((self.portfolioData?.content![portfolioIdx].portfolioId)!)
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArtistPortfolioManageViewController {
    private func getAllPortfolio() {
        let getAllPortfolio = PortfolioManager.shared
        getAllPortfolio.getAllPortfolio(artistId: artistId, page: page) { [weak self] result in
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
