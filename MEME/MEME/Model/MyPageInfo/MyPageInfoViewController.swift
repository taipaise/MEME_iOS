//
//  MyPageInfoViewController.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit

private let cellID2 = "Cell2"

class MyPageInfoViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let infoMenu = ["닉네임","이름", "성별", "이메일"]
    let infoMenuRightText = ["차차", "김나령", "여성", "meme@naver.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.black

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
        
        navigationItem.title = "내 정보 수정"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)]
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.icBack, for: .normal)
        backButton.configuration?.imagePadding = 25
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension MyPageInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! InfoTableViewCell

        cell.infomenuLabel.text = infoMenu[indexPath.row]
        cell.rightLabel.text = infoMenuRightText[indexPath.row]

        return cell
    }

    
}

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
