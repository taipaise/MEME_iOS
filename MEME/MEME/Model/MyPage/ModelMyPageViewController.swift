//
//  MyPageViewController.swift
//  MEME
//
//  Created by 임아영 on 1/12/24.
//

import UIKit

private let cellID = "Cell"

class ModelMyPageViewController: UIViewController, ModelHeaderViewDelegate {
        
    let tableView = UITableView(frame: .zero, style: .grouped)
    let myPageMenu = ["상세 정보 수정","약관 및 정책", "문의하기", "로그아웃", "탈퇴하기"]
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
                        
        configureUI()
        
        navigationItem.backButtonTitle = ""

    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        tableView.backgroundColor = .white

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ModelMyPageTableViewCell.self, forCellReuseIdentifier: cellID)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        navigationItem.title = "마이 페이지"
        navigationController?.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]

//뒤로가기 버튼
//        let rightBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(rightBarButtonDidTap))
//                navigationItem.rightBarButtonItem = rightBarButton
            }
    
    // 네비개이션 바 뒤로가기 액션 정의 필요
//    @objc func rightBarButtonDidTap() {
//    }
}

extension ModelMyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ModelMyPageTableViewCell
        
        cell.menuLabel.text = myPageMenu[indexPath.row ]
        cell.accessoryType = .disclosureIndicator
                
        return cell
    }
    
}

extension ModelMyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ModelHeaderView()
        
        header.delegate = self
        
        header.backgroundColor = .white
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 301
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 49
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .white

        let versionLabel = UILabel()
        versionLabel.text = "앱 버전"
        versionLabel.textAlignment = .left
        versionLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) // #999999
        versionLabel.font = UIFont.systemFont(ofSize: 12)

        let versionNumberLabel = UILabel()
        versionNumberLabel.text = "1.0.0"
        versionNumberLabel.textAlignment = .right
        versionNumberLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) // #999999
        versionNumberLabel.font = UIFont.systemFont(ofSize: 12)

        footerView.addSubview(versionLabel)
        footerView.addSubview(versionNumberLabel)

        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionNumberLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            versionLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 24),
            versionLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            versionNumberLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            versionNumberLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 37
    }
    
    func buttonClicked() {
        let MyPageInfoViewController = MyPageInfoViewController()
        self.navigationController?.pushViewController(MyPageInfoViewController, animated: true)
        }
}

