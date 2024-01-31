//
//  ArtistPortfolioEditingViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/28/24.
//

import UIKit

class ArtistPortfolioEditingViewController: UIViewController {
    var pastIndex: IndexPath?

    @IBOutlet private var makeupCategoryCollectionView: UICollectionView!
    @IBOutlet var imagePickerStackView: UIStackView!
    
    private let artistProfileEditingInfoBar: UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBold
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        makeConstraints()
        collectionViewConfigure()
    }
    private func collectionViewConfigure(){
        makeupCategoryCollectionView.delegate = self
        makeupCategoryCollectionView.dataSource = self
        makeupCategoryCollectionView.register(UINib(nibName: "ArtistMakeupTagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistMakeupTagCollectionViewCell")
        
    }
    
    private func configureSubviews() {
        view.addSubview(artistProfileEditingInfoBar)
    }
    private func makeConstraints() {
        artistProfileEditingInfoBar.snp.makeConstraints {make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(49)
        }
    }
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @objc func editButtonDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "포트폴리오 수정하기", message: "\n포트폴리오를 수정하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default, handler : nil )
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler : nil )
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func trashButtonDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "포트폴리오 삭제하기", message: "\n포트폴리오를 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default, handler : nil )
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler : nil )
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ArtistPortfolioEditingViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makeupCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistMakeupTagCollectionViewCell", for: indexPath) as? ArtistMakeupTagCollectionViewCell else { return UICollectionViewCell() }
        cell.makeupTagLabel.text = makeupCategoryArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 indexPath에 대한 셀을 가져오기
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ArtistMakeupTagCollectionViewCell {
            // 선택된 셀에 대한 작업 수행
            selectedCell.selected()
        }
        
        // 나머지 indexPath에 대한 셀을 가져와서 작업 수행
        for visibleIndexPath in collectionView.indexPathsForVisibleItems {
            if visibleIndexPath != indexPath,
               let deselectedCell = collectionView.cellForItem(at: visibleIndexPath) as? ArtistMakeupTagCollectionViewCell {
                // 선택되지 않은 셀에 대한 작업 수행
                deselectedCell.deSelected()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = 97
        if(indexPath.row == 3){
            width += 23
        }else if(indexPath.row == 6){
            width += 8
        }else if(indexPath.row == 7){
            width += 38
        }
        return CGSize(width : width, height: 27)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
}
