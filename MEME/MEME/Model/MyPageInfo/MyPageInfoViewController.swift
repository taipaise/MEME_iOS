//
//  MyPageInfoViewController.swift
//  MEME
//
//  Created by 임아영 on 1/15/24.
//

import UIKit

private let cellID2 = "Cell2"

class MyPageInfoViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let infoMenu = ["닉네임","이름", "성별", "이메일"]
    let infoMenuRightText = ["차차", "김나령", "여성", "meme@naver.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
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
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]

        //뒤로가기 버튼
        //        let rightBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(rightBarButtonDidTap))
        //                navigationItem.rightBarButtonItem = rightBarButton
                    }
            
            // 네비개이션 바 뒤로가기 액션 정의 필요
        //    @objc func rightBarButtonDidTap() {
        //    }
    
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
