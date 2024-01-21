//
//  ArtistProfilePreviewViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/14/24.
//

import UIKit

class ArtistProfilePreviewViewController: UIViewController {
    @IBOutlet var makeupTagCollectionView: UICollectionView!
    @IBOutlet var portfolioCollectionView: UICollectionView!
    @IBOutlet var bottomBarView: UIView!
    
    // 더미데이터
    private var subtitleArray : [String] = ["데일리 메이크업","배우 메이크업","배우 메이크업"]
    private var makeUpNameArray : [String] = ["메이크업명1","메이크업명2","메이크업명3"]
    private var priceArray : [String] = ["가격1","가격2","가격3"]
    private var imageArray : [String] = ["logo","logo","logo"]
    
    
    private var makeupTagArray : [String] = ["데일리 메이크업", "기본 메이크업", "특수 메이크업", "기본 메이크업", "특수 메이크업"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfig()
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
        self.navigationController?.popViewController(animated: true)
    }

}

extension ArtistProfilePreviewViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == makeupTagCollectionView{
            return makeupTagArray.count
        }else if collectionView == portfolioCollectionView{
            return makeUpNameArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == makeupTagCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistMakeupTagCollectionViewCell", for: indexPath) as? ArtistMakeupTagCollectionViewCell else { return UICollectionViewCell() }
            cell.makeupTagLabel.text = makeupTagArray[indexPath.row]
            return cell
            
        }else if collectionView == portfolioCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistPortfolioCollectionViewCell", for: indexPath) as? ArtistPortfolioCollectionViewCell else { return UICollectionViewCell() }
            cell.portfolioMainLabel.text = makeUpNameArray[indexPath.row]
            cell.portfolioSubLabel.text = subtitleArray[indexPath.row]
            cell.portfolioPriceLabel.text = priceArray[indexPath.row]
            cell.portfolioImageView.image = UIImage(named: imageArray[indexPath.row])
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
