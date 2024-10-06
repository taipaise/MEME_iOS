import UIKit
import SnapKit

class ReservationHeaderView: UICollectionReusableView {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with dateString: String) {
        dateLabel.text = dateString
    }
}
