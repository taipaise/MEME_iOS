//
//  ModelInfoHeaderView.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit

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
        
        infoprofileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(infoprofileImage)
        NSLayoutConstraint.activate([
            infoprofileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoprofileImage.widthAnchor.constraint(equalToConstant: 90),
            infoprofileImage.heightAnchor.constraint(equalToConstant: 90),
            infoprofileImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
        
        addSubview(nameLabel)
        nameLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: infoprofileImage.bottomAnchor, constant: 17)
        ])
        MyPageManager.shared.getMyPageProfile(userId: 6) { [weak self] result in
            switch result {
            case .success(let response):
                self?.myPageResponse = response
                
                // UI 업데이트
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
