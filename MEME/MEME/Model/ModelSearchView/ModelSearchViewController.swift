//
//  ModelSearchViewController.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import UIKit
import SwiftUI

class ModelSearchViewController: UIViewController {
    //MARK: -Properties
    let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.backgroundColor = UIColor.white
        
        return backButton
    }()
    let searchMakeup: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "원하는 메이크업을 검색해보세요."
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 20
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1).cgColor
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        let textField = searchBar.searchTextField
            textField.backgroundColor = .white
            textField.textColor = .black
        
        if let leftView = textField.leftView as? UIImageView {
                leftView.tintColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1)
            }
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1)]
            textField.attributedPlaceholder = NSAttributedString(string: "원하는 메이크업을 검색해보세요.", attributes: placeholderAttributes)
        searchBar.tintColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1)
        
        return searchBar
    }()
    var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    var recentSearchesCollectionView: UICollectionView!
    var categorySearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리로 찾기"
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    var categorySearchesCollectionView: UICollectionView!
    var artistSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 아티스트로 찾기"
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    let Artist1Button: UIButton = {
        let button = UIButton()
        button.setTitle("아티스트명", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        
        button.layer.borderColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    let Artist2Button: UIButton = {
        let button = UIButton()
        button.setTitle("아티스트명", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        
        button.layer.borderColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()

    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupRecentSearchCollectionView()
        setupSearchCollectionView()
        configureSubviews()
        makeConstraints()
        

    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(backButton)
        view.addSubview(searchMakeup)
        view.addSubview(recentSearchesLabel)
        view.addSubview(recentSearchesCollectionView)
        view.addSubview(categorySearchesLabel)
        view.addSubview(categorySearchesCollectionView)
        view.addSubview(artistSearchesLabel)
        view.addSubview(Artist1Button)
        view.addSubview(Artist2Button)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        backButton.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        searchMakeup.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(backButton.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(40)
        }
        recentSearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(backButton.snp.bottom).offset(42)
            make.leading.equalToSuperview().offset(24)
        }
        recentSearchesCollectionView.snp.makeConstraints {make in
            make.top.equalTo(recentSearchesLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(30)
        }
        categorySearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(recentSearchesCollectionView.snp.bottom).offset(31)
            make.leading.equalToSuperview().offset(24)
        }
        categorySearchesCollectionView.snp.makeConstraints {make in
            make.top.equalTo(categorySearchesLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(405)
        }
        artistSearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(categorySearchesCollectionView.snp.bottom).offset(27)
            make.leading.equalToSuperview().offset(24)
        }
        Artist1Button.snp.makeConstraints {make in
            make.top.equalTo(artistSearchesLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(68)
        }
        Artist2Button.snp.makeConstraints {make in
            make.centerY.equalTo(Artist1Button.snp.centerY)
            make.leading.equalTo(Artist1Button.snp.trailing).offset(5)
            make.width.equalTo(68)
        }
    }

    // MARK: - Navigation
    
    //MARK: -Actions
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: -Helpers
    private func setupRecentSearchCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        recentSearchesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        recentSearchesCollectionView.delegate = self
        recentSearchesCollectionView.dataSource = self
        
        //cell 등록
        recentSearchesCollectionView.register(UINib(nibName: "RecentSearchViewCell", bundle: nil), forCellWithReuseIdentifier: RecentSearchViewCell.identifier)
    }
    private func setupSearchCollectionView() {
        let layout = UICollectionViewFlowLayout()
        categorySearchesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        categorySearchesCollectionView.delegate = self
        categorySearchesCollectionView.dataSource = self
        
        //cell 등록
        categorySearchesCollectionView.register(UINib(nibName: "CategorySearchViewCell", bundle: nil), forCellWithReuseIdentifier: CategorySearchViewCell.identifier)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ModelSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == recentSearchesCollectionView {
            return 1
            }  else if collectionView == categorySearchesCollectionView{
                return 1
            }
        return 1
    }
    
    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentSearchesCollectionView {
            return 8
            }  else if collectionView == categorySearchesCollectionView{
                return 8
            }
        return 0
    }
    
    //cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentSearchesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchViewCell.identifier, for: indexPath) as? RecentSearchViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            return cell
            }  else if collectionView == categorySearchesCollectionView{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySearchViewCell.identifier, for: indexPath) as? CategorySearchViewCell else {
                    fatalError("셀 타입 캐스팅 실패...")
                }
                return cell
            }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ModelSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recentSearchesCollectionView {
            return CGSize(width: 107, height: 28)
            }  else if collectionView == categorySearchesCollectionView{
                return CGSize(width: 95, height: 115)
            }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == recentSearchesCollectionView {
            return CGFloat(10)
            }  else if collectionView == categorySearchesCollectionView{
                return CGFloat(25)
            }
        return CGFloat(20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == recentSearchesCollectionView {
            return CGFloat(10)
            }  else if collectionView == categorySearchesCollectionView{
                return CGFloat(20)
            }
        return CGFloat(25)
    }
}
