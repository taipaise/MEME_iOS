//
//  InterestArtistViewController.swift
//  MEME
//
//  Created by 임아영 on 1/21/24.
//

import UIKit

class InterestArtistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cellId = "cellId"
    
    struct Artist {
        let name: String
    }

    var data = [ArtistContent]()

    var collectionView: UICollectionView!
    
    let totalLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
//        let artist1 = Artist(name: "아티스트1")
//        let artist2 = Artist(name: "아티스트2")
//        let artist3 = Artist(name: "아티스트3")
//        let artist4 = Artist(name: "아티스트4")
//        data = [artist1, artist2, artist3, artist4]
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 57, left: 28, bottom: 10, right: 28)
        layout.itemSize = CGSize(width: 154, height: 193)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Gray100")
        collectionView.register(InterestArtistCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)

        configureUI()
    }

    func configureUI() {
        
        navigationItem.title = "관심 아티스트"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)]
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.icBack, for: .normal)
        backButton.configuration?.imagePadding = 25
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.tabBarController?.tabBar.isHidden = true
        
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(totalLabel)
        totalLabel.text = "총 \(data.count)명"
        NSLayoutConstraint.activate([
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            totalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27)
        ])

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return data.count
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? InterestArtistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let artist = data[indexPath.item]
        cell.titleLabel.text = artist.artistNickName
        
        let profileImgUrl = artist.profileImg
        FirebaseStorageManager.downloadImage(urlString: profileImgUrl) { image in
            DispatchQueue.main.async {
                guard let image = image else { return }
                cell.imageView.image = image
            }
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modelViewArtistProfileViewController = ModelViewArtistProfileViewController()
        self.navigationController?.pushViewController(modelViewArtistProfileViewController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: -API 통신 메소드
extension InterestArtistViewController {
    func getInterestArtist(modelId: Int, artistId: Int, portfolioId: Int, artistNickName: String, makeupName: String, reservationDate: String, profileImg: String) {
        InterestArtistManager.shared.getInterestArtist(modelId: 1, artistId: artistId, artistNickName: artistNickName,  profileImg: profileImg)  { [weak self] result in
            switch result {
            case .success(let response):
                print("Success: \(response)")
                self?.data = response.data?.content ?? []
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.totalLabel.text = "총 \(self?.data.count ?? 0)명"
                }
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
}
