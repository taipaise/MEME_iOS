//
//  SortOptionIconView.swift
//  MEME
//
//  Created by 정민지 on 1/21/24.
//

import UIKit
import SnapKit

class SortOptionButton: UIButton {
    // MARK: - Properties
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 10
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var sortImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        return imageView
    }()
    
    public var text: String? {
        didSet { label.text = text }
    }
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        sortImageView.image = image
    }
    
    private func setUp() {
        addSubview(stackView)
        [label, sortImageView].forEach(stackView.addArrangedSubview(_:))
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(23)
            make.trailing.equalToSuperview().offset(-23)
        }
    }
}
