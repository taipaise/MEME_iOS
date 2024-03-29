//
//  InterestMakeUpCollectionViewController.swift
//  MEME
//
//  Created by 임아영 on 1/28/24.
//

import UIKit
import SnapKit

private let cellId = "cellId"
class InterestMakeUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    struct MakeUp {
        let type: String
        let name: String
        let price: Int
    }
    var data = [MakeupContent]()
    
    var collectionView: UICollectionView!
    
    let totalLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InterestMakeUpManager.shared.getInterestMakeUp(modelId: 1, portfolioId: 3,  portfolioImg: "URL", category: "Category", makeupName: "Name", artistName: "ArtistName", price: 20000, makeupLocation: "makeupLocation") { [weak self] result in
            switch result {
            case .success(let response):
                print("Success: \(response)")
                self?.data = response.data.content 
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.totalLabel.text = "총 \(self?.data.count ?? 0)명"
                }
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
//        let makeup1 = MakeUp(type:"데일리 메이크업", name: "메이크업명", price: "가격")
//        let makeup2 = MakeUp(type:"배우 메이크업", name: "메이크업명", price: "가격")
//        let makeup3 = MakeUp(type:"데일리 메이크업", name: "메이크업명", price: "가격")
//        let makeup4 = MakeUp(type:"배우 메이크업", name: "메이크업명", price: "가격")
//        data = [makeup1, makeup2, makeup3, makeup4]
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 57, left: 28, bottom: 10, right: 28)
        layout.itemSize = CGSize(width: 154, height: 222)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Gray100")
        collectionView.register(InterestMakeUpCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        configureUI()
    }
    
    func configureUI() {
        
        navigationItem.title = "관심 메이크업"
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
        totalLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(27)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? InterestMakeUpCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let makeup = data[indexPath.item]
        cell.typeLabel.text = makeup.category
        cell.titleLabel.text = makeup.makeupName
        cell.priceLabel.text = String(makeup.price)
        
        let profileImgUrl = makeup.portfolioImg
        FirebaseStorageManager.downloadImage(urlString: profileImgUrl) { image in
            DispatchQueue.main.async {
                guard let image = image else { return }
                cell.imageView.image = image
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modelReservationViewController = ModelReservationViewController()
        self.navigationController?.pushViewController(modelReservationViewController, animated: true)
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
