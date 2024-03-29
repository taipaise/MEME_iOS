//
//  MyPageInfoViewController.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit

private let cellID2 = "Cell2"

class MyPageInfoViewController: UIViewController, UITableViewDataSource {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let infoMenu = ["닉네임","이름", "성별", "이메일"]
    
    var myPageResponse: MyPageResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyPageManager.shared.getMyPageProfile(userId: KeyChainManager.loadMemberID()) { [weak self] result in
            switch result {
            case .success(let profile):
                print("Success: \(profile)")
                self?.myPageResponse = profile
                self?.tableView.reloadData()
                self?.updateHeaderView()

            case .failure(let error):
                print("Failure: \(error)")
            }
        }
            configureUI()
            
            self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func updateHeaderView() {
                guard let header = tableView.tableHeaderView as? ModelHeaderView else { return }
                
        if let nickname = myPageResponse?.data?.name {
                    header.namebutton.setTitle(nickname, for: .normal)
                }
    //            if let profileImgUrl = data?.data?.profileImg {
    //                header.profileImage.loadImage(from: profileImgUrl)
    //            }
        if let profileImgUrl = myPageResponse?.data?.profileImg {
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
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

    func configureUI() {
        
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: cellID2)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        self.tabBarController?.tabBar.isHidden = true
        
        navigationItem.title = "내 정보 조회"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)]
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.icBack, for: .normal)
        backButton.configuration?.imagePadding = 25
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
       }
    

    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageResponse != nil ? infoMenu.count : 0
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! InfoTableViewCell

        cell.infomenuLabel.text = infoMenu[indexPath.row]
        cell.rightLabel.text = profileValue(for: indexPath.row)

        return cell
    }
    private func profileValue(for index: Int) -> String? {
        guard let data = myPageResponse?.data else { return nil }
        switch index {
        case 0:
            return data.nickname
        case 1:
            return data.name
        case 2:
            return data.gender
        case 3:
            return data.email
        default:
            return nil
        }
    }
    
}


//var myPageResponse: MyPageResponse?
//
//extension MyPageInfoViewController: UITableViewDataSource {}

extension MyPageInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = InfoHeaderView()
        
        header.backgroundColor = .white
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 218
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 49
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//
//extension UIImageView {
//    func setImage(image: UIImage?) {
//        DispatchQueue.main.async {
//            self.image = image
//        }
//    }
//}
