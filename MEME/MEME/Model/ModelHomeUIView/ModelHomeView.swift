//
//  ModelHomeView.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import UIKit

class ModelHomeView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Subviews
    let modelProfileImageView = UIImageView()
    let modelWelcomeSubLabel = UILabel()
    let modelWelcomeMainLabel = UILabel()
    private var collectionView: UICollectionView!
    
    // MARK: - Properties
    var reservations: [ModelMyReservation] = []
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupLabelsAndImages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCollectionView()
        setupLabelsAndImages()
    }
    
    // MARK: - Setup CollectionView for reservationConfirmView
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ModelReservationConfirmView.self, forCellWithReuseIdentifier: "ReservationConfirmCell")
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: modelWelcomeMainLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Setup other labels and image view
    private func setupLabelsAndImages() {
        modelProfileImageView.image = ModelDataService.shared.currentModel?.profileImage
               

        modelWelcomeSubLabel.text = ModelDataService.shared.currentModel?.name ?? "User" + "님, 환영합니다!"
        modelWelcomeSubLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        // Welcome main label setup
        modelWelcomeMainLabel.text = ModelDataService.shared.currentModel?.name ?? "User" + "님, 환영합니다!"
        modelWelcomeMainLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        addSubview(modelProfileImageView)
        addSubview(modelWelcomeSubLabel)
        addSubview(modelWelcomeMainLabel)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationConfirmCell", for: indexPath) as? ModelReservationConfirmView else {
            fatalError("Unable to dequeue ReservationConfirmCell")
        }
        let reservation = reservations[indexPath.item]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.frame.height)
    }
}
