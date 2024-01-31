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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfig()
        uiSet()
    }
    
    private func uiSet(){
        self.navigationController?.isNavigationBarHidden = true
        noPortfolioLabel.isHidden = !portfolioMakeupNameArray.isEmpty
    }
    private func collectionViewConfig(){
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        portfolioCollectionView.register(UINib(nibName: "ArtistPortfolioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistPortfolioCollectionViewCell")

    }
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func portfolioAddButtonDidTap(_ sender: UIButton) {
        let vc = ArtistPortfolioEditingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArtistPortfolioManageViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return portfolioMakeupNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistPortfolioCollectionViewCell", for: indexPath) as? ArtistPortfolioCollectionViewCell else { return UICollectionViewCell() }
        cell.portfolioMainLabel.text = portfolioMakeupNameArray[indexPath.row]
        cell.portfolioSubLabel.text = portfolioMakeupTagArray[indexPath.row]
        cell.portfolioPriceLabel.text = portfolioPriceArray[indexPath.row]
        cell.portfolioImageView.image = UIImage(named: portfolioImageArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ArtistPortfolioEditingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
