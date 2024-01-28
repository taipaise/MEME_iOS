//
//  ArtistPortfolioEditingViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/28/24.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func makeupTagDidTap(_ cell: ArtistMakeupTagCollectionViewCell)
}

class ArtistPortfolioEditingViewController: UIViewController {
    var pastIndex: IndexPath?

    @IBOutlet var makeupTagCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func makeupTagDidTap(_ cell: ArtistMakeupTagCollectionViewCell) {
        guard let currentIndex = makeupTagCollectionView.indexPath(for: cell) else {
                    return
                }

                if let pastIndex = pastIndex, pastIndex.section == currentIndex.section, pastIndex.item == currentIndex.item {
                    cell.makeupTagView.backgroundColor = .gray100
                    cell.makeupTagLabel.textColor = .gray500
                    cell.tagSelected = false
                }

                pastIndex = currentIndex
    }
    
}
