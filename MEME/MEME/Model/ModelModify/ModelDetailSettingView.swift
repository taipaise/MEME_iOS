//
//  DetailSettingView.swift
//  MEME
//
//  Created by 이동현 on 1/17/24.
//

import UIKit

protocol DetailSetButtonTapped: AnyObject {
    func detailSetButtonTapped(
        isSelected: Bool,
        tag: Int,
        type: DetailSetViewType
    )
}

enum DetailSetViewType {
    case gender
    case skinType
    case personalColor
}

final class ModelDetailSettingView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    
    

    weak var delegate: DetailSetButtonTapped?
    private var type: DetailSetViewType = .gender
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        loadNib()
        backgroundColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderColor = UIColor.gray400.cgColor
    }
    
    func configure(
        title: String,
        tag: Int,
        type: DetailSetViewType
    ) {
        label.text = title
        label.font = .pretendard(to: .regular, size: 14)
        button.tag = tag
        self.type = type


    }

    
    
    @IBAction func buttonTapped(_ sender: Any) {

        button.isSelected.toggle()
        if button.isSelected {
            imageView.image = .detailSelected
        } else {
            deselect(tag: -1)
        }
        
        delegate?.detailSetButtonTapped(
            isSelected: button.isSelected,
            tag: button.tag,
            type: type
        )
    }
    
    func deselect(tag: Int) {
        if button.tag != tag {
            button.isSelected = false
            imageView.image = nil
        }
    }
    func setSelected() {
        button.isSelected = true
        imageView.image = .detailSelected
    }

}
