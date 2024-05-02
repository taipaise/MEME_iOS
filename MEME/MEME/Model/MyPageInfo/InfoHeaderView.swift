//
//  ModelInfoHeaderView.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit
import SnapKit

class InfoHeaderView: UIView {
    
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
        
        return label
    }()
    
    var myPageResponse: MyPageResponse?

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(infoprofileImage)
        infoprofileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(50)
        }
           
        addSubview(nameLabel)
        nameLabel.font = .pretendard(to: .semiBold, size: 18)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoprofileImage.snp.bottom).offset(17)
        }
        
        MyPageManager.shared.getMyPageProfile(userId: KeyChainManager.loadMemberID()) { [weak self] result in
            switch result {
            case .success(let response):
                self?.myPageResponse = response
                
                DispatchQueue.main.async {
                    self?.nameLabel.text = response.data?.name
                    if let profileImgUrl = response.data?.profileImg {
                        self?.infoprofileImage.loadImage(from: profileImgUrl)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
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
