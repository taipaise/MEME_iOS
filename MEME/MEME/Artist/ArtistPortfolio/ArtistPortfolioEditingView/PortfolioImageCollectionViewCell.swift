import UIKit
import SnapKit

protocol PortfolioImageCollectionViewCellDelegate: AnyObject {
    func deleteButtonTapped(_ cell: PortfolioImageCollectionViewCell)
}

class PortfolioImageCollectionViewCell: UICollectionViewCell {
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(.icDelete, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var portfolioImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "portfolio_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    weak var delegate: PortfolioImageCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(portfolioImageView)
        contentView.addSubview(deleteButton)
        makeConstraints()
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
    }
    
    private func makeConstraints(){
        portfolioImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.height.width.equalTo(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteButtonTapped(self)
    }
    
    func configure(image: UIImage) {
        portfolioImageView.image = image
    }
    func hideDeleteButton(_ option: Bool) {
        deleteButton.isHidden = option
    }
}
