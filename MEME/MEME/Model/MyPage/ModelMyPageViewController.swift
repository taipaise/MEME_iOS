//
//  MyPageViewController.swift
//  MEME
//
//  Created by 임아영 on 1/12/24.
//

import UIKit
import SnapKit

private let cellID = "Cell"

class ModelMyPageViewController: UIViewController, ModelHeaderViewDelegate {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let myPageMenu = ["프로필 관리","약관 및 정책", "문의하기", "로그아웃", "탈퇴하기"]
    
    // MARK: - Lifecycle
    var data: MyPageResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfileData()
        setupViews()
        setupConstraints()
        
        navigationItem.backButtonTitle = ""
    }

    func loadProfileData() {
        MyPageManager.shared.getMyPageProfile(userId: KeyChainManager.loadMemberID()) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.data = response
                    self?.updateHeaderView()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

        func updateHeaderView() {
            guard let header = tableView.tableHeaderView as? ModelHeaderView else { return }
            
            if let nickname = data?.data?.nickname {
                header.namebutton.setTitle(nickname, for: .normal)
            }
            if let profileImgUrl = data?.data?.profileImg {
                header.profileImage.loadImage(from: profileImgUrl)
            }
            if let profileImgUrl = data?.data?.profileImg {
                    FirebaseStorageManager.downloadImage(urlString: profileImgUrl) { image in
                        guard let image = image else { return }
                        header.profileImage.setImage(image: image)
                    }
                }
                
                tableView.layoutIfNeeded()
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    func setupViews() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ModelMyPageTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 1))
        
        navigationItem.title = "마이 페이지"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)
        ]
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.bottom.equalTo(view.snp.bottom)
            make.right.equalTo(view.snp.right)
        }
    }
}

extension ModelMyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ModelMyPageTableViewCell else {
            fatalError("The dequeued cell is not an instance of ModelMyPageTableViewCell.")
        }
        
        cell.menuLabel.text = myPageMenu[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        let separatorView = UIView()
        separatorView.backgroundColor = tableView.separatorColor
        cell.contentView.addSubview(separatorView)

        separatorView.snp.makeConstraints { make in
            make.bottom.equalTo(cell.contentView.snp.bottom)
            make.leading.equalTo(cell.contentView.snp.leading).offset(24)
            make.trailing.equalTo(cell.contentView.snp.trailing)
            make.height.equalTo(1)
        }
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
            let modelModifyViewController = ModelModifyViewController()
            self.navigationController?.pushViewController(modelModifyViewController, animated: true)
        }
        if indexPath.row == 1 {
            let provisionViewController = ProvisionViewController()
            self.navigationController?.pushViewController(provisionViewController, animated: true)
        }
        if indexPath.row == 2 {
            let askViewController = AskViewController()
            self.navigationController?.pushViewController(askViewController, animated: true)
        }
        if indexPath.row == 3 {
            let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                Task {
                    let result = await AuthManager.shared.logout()
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            let nextVC = LoginViewController()
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
                        case .failure(let error):
                            self.showErrorAlert(message: "로그아웃 실패: \(error.localizedDescription)")
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        if indexPath.row == 4 {
            let alert = UIAlertController(title: "탈퇴", message: "정말 탈퇴 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                Task {
                    let result = await AuthManager.shared.leave()
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            let nextVC = LoginViewController()
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
                        case .failure(let error):
                            self.showErrorAlert(message: "탈퇴 실패: \(error.localizedDescription)")
                        }
                    }
                }
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
        versionLabel.textColor = .gray400
        versionLabel.font = .pretendard(to: .regular, size: 12)
        
        let versionNumberLabel = UILabel()
        versionNumberLabel.text = "1.0.0"
        versionNumberLabel.textAlignment = .right
        versionNumberLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        versionNumberLabel.font = UIFont.systemFont(ofSize: 12)
        
        footerView.addSubview(versionLabel)
        footerView.addSubview(versionNumberLabel)
        
        versionLabel.snp.makeConstraints { make in
            make.leading.equalTo(footerView.snp.leading).offset(24)
            make.centerY.equalTo(footerView.snp.centerY)
        }
        versionNumberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(footerView.snp.trailing).offset(-20)
            make.centerY.equalTo(footerView.snp.centerY)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 37
    }
    
    func buttonClicked() {
        let myPageInfoViewController = MyPageInfoViewController()
        self.navigationController?.pushViewController(myPageInfoViewController, animated: true)
    }
    
    func mpArtistClicked() {
        let interestArtistViewController = InterestArtistViewController()
        self.navigationController?.pushViewController(interestArtistViewController, animated: true)
    }
    
    func mpMakeUpClicked() {
        let interestMakeUpViewController = InterestMakeUpViewController()
        self.navigationController?.pushViewController(interestMakeUpViewController, animated: true)
    }
    func myReviewClicked() {
        let myReviewViewController = ReviewViewController()
        self.navigationController?.pushViewController(myReviewViewController, animated: true)
    }
}

extension ModelMyPageViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension UIImageView {
    func setImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
}

