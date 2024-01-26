//
//  ArtistProfilePreviewViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/14/24.
//

import UIKit

class ArtistProfilePreviewViewController: UIViewController {
    @IBOutlet private var makeupTagCollectionView: UICollectionView!
    @IBOutlet private var portfolioCollectionView: UICollectionView!
    @IBOutlet private var bottomBarView: UIView!
    @IBOutlet private var artistGenderView: UIView!
    @IBOutlet private var artistShopView: UIView!
    @IBOutlet private var artistVisitingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfig()
        uiSet()
    }
    
    private func uiSet(){
        navigationController?.isNavigationBarHidden = true
        artistGenderView.layer.borderColor = UIColor(resource: .mainBold).cgColor
        artistGenderView.layer.cornerRadius = artistGenderView.frame.height/2
        artistGenderView.layer.borderWidth = 1
        
        artistShopView.backgroundColor = UIColor(resource: .mainBold)
        artistShopView.layer.cornerRadius = artistShopView.frame.height/2

        artistVisitingView.backgroundColor = UIColor(resource: .mainBold)
        artistVisitingView.layer.cornerRadius = artistVisitingView.frame.height/2
        bottomBarView.layer.cornerRadius = 10
    }
    
    private func collectionViewConfig(){
        makeupTagCollectionView.delegate = self
        makeupTagCollectionView.dataSource = self
        makeupTagCollectionView.register(UINib(nibName: "ArtistMakeupTagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistMakeupTagCollectionViewCell")

        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.register(UINib(nibName: "ArtistPortfolioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistPortfolioCollectionViewCell")

    }
    
    @IBAction private func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

extension ArtistProfilePreviewViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == makeupTagCollectionView{
            return portfolioMakeupTagArray.count
        }else if collectionView == portfolioCollectionView{
            return portfolioMakeupNameArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == makeupTagCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistMakeupTagCollectionViewCell", for: indexPath) as? ArtistMakeupTagCollectionViewCell else { return UICollectionViewCell() }
            cell.makeupTagLabel.text = profilemakeupTagArray[indexPath.row]
            return cell
            
        }else if collectionView == portfolioCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistPortfolioCollectionViewCell", for: indexPath) as? ArtistPortfolioCollectionViewCell else { return UICollectionViewCell() }
            cell.portfolioMainLabel.text = portfolioMakeupNameArray[indexPath.row]
            cell.portfolioSubLabel.text = portfolioMakeupTagArray[indexPath.row]
            cell.portfolioPriceLabel.text = portfolioPriceArray[indexPath.row]
            cell.portfolioImageView.image = UIImage(named: portfolioImageArray[indexPath.row])
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
