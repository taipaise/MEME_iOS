//
//  InfoHeaderView.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit
import SnapKit

class InfoHeaderView: UIView {
    
    weak var delegate: InfoHeaderViewDelegate?

    
    let infoprofileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.profile
        iv.layer.cornerRadius = 90 / 2
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "차차"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    
    var myPageResponse: MyPageResponse?

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func addSubViews() {
        addSubview(infoprofileImage)
        addSubview(nameLabel)
    }
    
    private func makeConstraints() {
        infoprofileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(50)
        }
           
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoprofileImage.snp.bottom).offset(17)
        }
    }
    
    func configure(name: String, profileImage: UIImage?) {
        nameLabel.text = name
        infoprofileImage.image = profileImage
    }

}

protocol InfoHeaderViewDelegate: AnyObject {
  }

extension UIImageView {
    func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, _, _) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
