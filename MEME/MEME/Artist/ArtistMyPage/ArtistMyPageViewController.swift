//
//  ArtistMyPageViewController.swift
//  MEME
//
//  Created by 임아영 on 2/3/24.
//

import UIKit

private let cellID = "Cell"

    class ArtistMyPageViewController: UIViewController, ArtistHeaderViewDelegate {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        let myPageMenu = ["약관 및 정책", "문의하기", "로그아웃", "탈퇴하기"]
        
        var myPageResponse: MyPageResponse?

        override func viewDidLoad() {
            super.viewDidLoad()
                
            MyPageManager.shared.getMyPageProfile(userId: KeyChainManager.loadMemberID()) { [weak self] result in
                switch result {
                case .success(let profile):
                    print("Success: \(profile)")
                    self?.myPageResponse = profile
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
                
            
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
            tableView.separatorStyle = .none
            
            tableView.register(ModelMyPageTableViewCell.self, forCellReuseIdentifier: cellID)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
            
            navigationItem.title = "마이 페이지"
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)]
            
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 1))
            
        }
        
        func buttonClicked() {
            let myPageInfoViewController = MyPageInfoViewController()
            self.navigationController?.pushViewController(myPageInfoViewController, animated: true)
        }
        func profileManage() {
            let artistInfoViewController = ArtistInfoViewController()
            self.navigationController?.pushViewController(artistInfoViewController, animated: true)
        }
        
        func portfolioManage() {
            let artistPortfolioManageViewController = ArtistPortfolioManageViewController()
            self.navigationController?.pushViewController(artistPortfolioManageViewController, animated: true)
        }
        func reservationManage() {
            self.tabBarController?.selectedIndex = 1
        }
    }

extension ArtistMyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ModelMyPageTableViewCell else {
            fatalError("The dequeued cell is not an instance of ModelMyPageTableViewCell.") //앱 종료 - 다른 예외처리가 필요할까요..
        }
        
        cell.menuLabel.text = myPageMenu[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        let separatorView = UIView()
        separatorView.backgroundColor = tableView.separatorColor
        cell.contentView.addSubview(separatorView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 24),
            separatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        return cell
    }
}

extension ArtistMyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ArtistHeaderView()
        
        header.delegate = self
        header.backgroundColor = .white
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 52
        } else {
            return 49
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let provisionViewController = ProvisionViewController()
            self.navigationController?.pushViewController(provisionViewController, animated: true)
        }
        if indexPath.row == 1 {
            let askViewController = AskViewController()
            self.navigationController?.pushViewController(askViewController, animated: true)
        }
        if indexPath.row == 2 {
            let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                let nextVC = LoginViewController()
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
            }))
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    if indexPath.row == 4 {
            let alert = UIAlertController(title: "탈퇴", message: "정말 탈퇴 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                let nextVC = LoginViewController()
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
            }))
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        if indexPath.row == 3 {
            let alert = UIAlertController(title: "탈퇴", message: "정말 탈퇴 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                // 탈퇴 처리 코드
            }))
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .white
        
        let versionLabel = UILabel()
        versionLabel.text = "앱 버전"
        versionLabel.textAlignment = .left
        versionLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        
        let versionNumberLabel = UILabel()
        versionNumberLabel.text = "1.0.0"
        versionNumberLabel.textAlignment = .right
        versionNumberLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
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
    
}

