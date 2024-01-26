//
//  ExtendedReservationChartViewController.swift
//  MEME
//
//  Created by 정민지 on 1/27/24.
//

import UIKit
import SnapKit

class ExtendedReservationChartViewController: ModelReservationChartViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // 기본적인 ModelReservationChartViewController의 로딩 로직을 수행
        super.configureSubviews()
        super.makeConstraints()


        setupMakeupSearchBar()
    }

    private func setupMakeupSearchBar() {
        view.addSubview(searchMakeup)
        searchMakeup.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }

        buttonScrollView.snp.remakeConstraints { make in
            make.top.equalTo(searchMakeup.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
}
