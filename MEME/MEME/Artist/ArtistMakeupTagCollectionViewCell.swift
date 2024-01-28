//
//  ArtistMakeupTagCollectionViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/18/24.
//

import UIKit

class ArtistMakeupTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var makeupTagLabel: UILabel!
    @IBOutlet var makeupTagView: UIView!
    weak var delegate: CollectionViewCellDelegate?
    static let identifier = "ArtistMakeupTagCollectionViewCell"
    var tagSelected : Bool = false

    static func nib() -> UINib {
        return UINib(nibName: "ArtistMakeupTagCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiSet()
    }
    private func uiSet(){
        makeupTagView.layer.borderColor = UIColor(resource: .mainBold).cgColor
        makeupTagView.layer.cornerRadius = makeupTagView.frame.height/2
        makeupTagView.layer.borderWidth = 1
        makeupTagView.backgroundColor = .gray100
        makeupTagLabel.textColor = .gray500
    }
    @IBAction func makeupTagButtonDidTap(_ sender: UIButton) {
        delegate?.makeupTagDidTap(self)
        if(tagSelected){
            makeupTagView.backgroundColor = .gray100
            makeupTagLabel.textColor = .gray500
            tagSelected = false
        }else{
            makeupTagView.backgroundColor = .mainBold
            makeupTagLabel.textColor = .gray100
            tagSelected = true
        }
    }
    
}
