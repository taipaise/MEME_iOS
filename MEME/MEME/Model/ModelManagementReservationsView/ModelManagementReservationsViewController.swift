//
//  ModelManagementReservationsViewController.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit
import SnapKit

final class ModelManagementReservationsViewController: UIViewController {
    // MARK: - Properties
    private var reservationCollectionView: UICollectionView!
    private let navigationBar = NavigationBarView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.delegate = self
        navigationBar.configure(title: "전체 예약 보기")
        
        setupReservationCollectionView()
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        reservationCollectionView.backgroundColor = .white
        view.addSubview(reservationCollectionView)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBar.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        reservationCollectionView.snp.makeConstraints {make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    //MARK: -Helpers
    private func setupReservationCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        reservationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        reservationCollectionView.delegate = self
        reservationCollectionView.dataSource = self
        
        //cell 등록
        reservationCollectionView.register(ModelManagementReservationsDateCollectionViewCell.self, forCellWithReuseIdentifier: ModelManagementReservationsDateCollectionViewCell.identifier)

  
        reservationCollectionView.register(UINib(nibName: "ModelReservationConfirmViewCell", bundle: nil), forCellWithReuseIdentifier: ModelReservationConfirmViewCell.identifier)
        
    }
}

//MARK: -UITableViewDataSource, UITableViewDelegate
extension ModelManagementReservationsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //cell의 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if [0, 2, 5].contains(indexPath.row) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelManagementReservationsDateCollectionViewCell.identifier, for: indexPath) as? ModelManagementReservationsDateCollectionViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            return cell
        } else  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelReservationConfirmViewCell.identifier, for: indexPath) as? ModelReservationConfirmViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.contentView.backgroundColor = .gray200
            cell.modelReservationLabel.textColor = .black
            cell.modelReservationMakeupNameLabel.textColor = .black
            cell.modelReservationArtistNameLabel.textColor = .black
            cell.modelReservationLocationLabel.textColor = .black
            cell.modelReservationPriceLabel.textColor = .black
            cell.cancelButton.backgroundColor = .gray300
            
            return cell
        }
    }
}

extension ModelManagementReservationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if [0, 2, 5].contains(indexPath.row) {
            return CGSize(
                width: collectionView.frame.width, height: 20)
        } else  {
            return CGSize(width: collectionView.frame.width, height: 142)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }
}

// MARK: -BackButtonTappedDelegate
extension ModelManagementReservationsViewController: BackButtonTappedDelegate  {
    func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
