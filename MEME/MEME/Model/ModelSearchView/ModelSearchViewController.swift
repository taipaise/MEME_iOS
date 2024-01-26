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
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    private let searchMakeup: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "원하는 메이크업을 검색해보세요."
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 20
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.mainBold.cgColor
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        let textField = searchBar.searchTextField
            textField.backgroundColor = .white
            textField.textColor = .black
        
        if let leftView = textField.leftView as? UIImageView {
            leftView.tintColor = .mainBold
            }
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainBold]
            textField.attributedPlaceholder = NSAttributedString(string: "원하는 메이크업을 검색해보세요.", attributes: placeholderAttributes)
        searchBar.tintColor = .mainBold
        
        return searchBar
    }()
    private var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private var allCancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 12)
        button.backgroundColor = .clear

        return button
    }()
    private let categorySearchesData = [("icon_daily", "데일리 메이크업"), ("icon_actor", "배우 메이크업"), ("icon_interview", "면접 메이크업"), ("icon_party", "파티/이벤트\n메이크업"), ("icon_wedding", "웨딩 메이크업"), ("icon_special", "특수 메이크업"), ("icon_studio", "스튜디오\n메이크업"), ("icon_etc", "기타(속눈썹,\n퍼스널 컬러)")]
    private var recentSearchesCollectionView: UICollectionView!
    private var categorySearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리로 찾기"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private var categorySearchesCollectionView: UICollectionView!
    private var artistSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 아티스트로 찾기"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private let Artist1Button: UIButton = {
        let button = UIButton()
        button.setTitle("아티스트명", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 10)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        
        button.layer.borderColor = UIColor(red: 255/255, green: 99/255, blue: 62/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    private let Artist2Button: UIButton = {
        let button = UIButton()
        button.setTitle("아티스트명", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 10)
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
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupSearchCollectionView()
        setupRecentSearchCollectionView()
        setupSearchMakeupBar()
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(searchMakeup)
        contentsView.addSubview(recentSearchesLabel)
        contentsView.addSubview(allCancelButton)
        recentSearchesCollectionView.backgroundColor = .white
        contentsView.addSubview(recentSearchesCollectionView)
        contentsView.addSubview(categorySearchesLabel)
        categorySearchesCollectionView.backgroundColor = .white
        contentsView.addSubview(categorySearchesCollectionView)
        contentsView.addSubview(artistSearchesLabel)
        contentsView.addSubview(Artist1Button)
        contentsView.addSubview(Artist2Button)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        scrollView.snp.makeConstraints {make in
            make.edges.equalToSuperview()
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        searchMakeup.snp.makeConstraints {make in
            make.top.equalTo(contentsView.snp.top).offset(16)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(40)
        }
        recentSearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(searchMakeup.snp.bottom).offset(42)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        allCancelButton.snp.makeConstraints {make in
            make.centerY.equalTo(recentSearchesLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        recentSearchesCollectionView.snp.makeConstraints {make in
            make.top.equalTo(recentSearchesLabel.snp.bottom).offset(3)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(30)
        }
        categorySearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(recentSearchesCollectionView.snp.bottom).offset(31)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        categorySearchesCollectionView.snp.makeConstraints {make in
            make.top.equalTo(categorySearchesLabel.snp.bottom).offset(9)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(450)
        }
        artistSearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(categorySearchesCollectionView.snp.bottom).offset(27)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        Artist1Button.snp.makeConstraints {make in
            make.top.equalTo(artistSearchesLabel.snp.bottom).offset(9)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.width.equalTo(68)
        }
        Artist2Button.snp.makeConstraints {make in
            make.centerY.equalTo(Artist1Button.snp.centerY)
            make.leading.equalTo(Artist1Button.snp.trailing).offset(5)
            make.width.equalTo(68)
            make.bottom.equalTo(contentsView.snp.bottom).offset(-20)
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
    private func setupSearchMakeupBar() {
        searchMakeup.delegate = self
        
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
                let data = categorySearchesData[indexPath.row]
                cell.categoryImageView.image = UIImage(named: data.0)
                cell.categoryLabel.text = data.1
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
                return CGSize(width: 95, height: 137)
            }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categorySearchesCollectionView {
                let totalWidth = collectionView.bounds.width
                let numberOfItemsPerRow: CGFloat = 3
                let cellWidth: CGFloat = 95
                let totalCellWidth = cellWidth * numberOfItemsPerRow
                let totalSpacingWidth = totalWidth - totalCellWidth
                let spacing = totalSpacingWidth / (numberOfItemsPerRow - 1)
                return spacing
            }
            return 10 
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == recentSearchesCollectionView {
            return CGFloat(10)
            }  else if collectionView == categorySearchesCollectionView{
                return CGFloat(7)
            }
        return CGFloat(25)
    }
}

//MARK: - UISearchBarDelegate
extension ModelSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text, !searchText.isEmpty {
            let extendedReservationChartVC = ExtendedReservationChartViewController()
            self.navigationController?.pushViewController(extendedReservationChartVC, animated: true)
        }
    }
}
