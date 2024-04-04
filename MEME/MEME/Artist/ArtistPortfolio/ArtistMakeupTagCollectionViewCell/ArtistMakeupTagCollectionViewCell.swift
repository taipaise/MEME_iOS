//
//  ArtistMakeupTagCollectionViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/18/24.
//

import UIKit

class ArtistMakeupTagCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Properties
    @IBOutlet weak var makeupTagLabel: UILabel!
    @IBOutlet weak var makeupTagView: UIView!

    static func nib() -> UINib {
        return UINib(nibName: ArtistMakeupTagCollectionViewCell.className, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    //MARK: - setUI()
    private func setUI(){
        makeupTagView.layer.borderColor = UIColor(resource: .mainBold).cgColor
        makeupTagView.layer.cornerRadius = makeupTagView.frame.height/2
        makeupTagView.layer.borderWidth = 1
        makeupTagView.backgroundColor = .gray100
        makeupTagLabel.textColor = .gray500
    }
    //MARK: - 셀 선택 시 UI 변화
    func selected(){
        makeupTagView.backgroundColor = .mainBold
        makeupTagLabel.textColor = .gray100
    }
    func deSelected(){
        makeupTagView.backgroundColor = .gray100
        makeupTagLabel.textColor = .gray500
    }
    
}
