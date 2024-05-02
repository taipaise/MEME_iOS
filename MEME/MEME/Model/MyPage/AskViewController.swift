//
//  AskViewController.swift
//  MEME
//
//  Created by 임아영 on 1/29/24.
//

import UIKit
import SnapKit

class AskViewController: UIViewController {
    
    let askLabel = UILabel()
    
    let emailLabel = UILabel()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.borderStyle = .none
        tf.layer.cornerRadius = 9
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray300.cgColor
        tf.placeholder = "제목을 입력해주세요."
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: tf.frame.height))
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let contentLabel = UILabel()
    
    let askTextView = UITextView()
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askTextView.delegate = self
        
        configureUI()
                
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
        
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "문의하기"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)]
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.icBack, for: .normal)
        backButton.configuration?.imagePadding = 25
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        askLabel.text = "문의할 내용을 남겨주세요."
        askLabel.font = .pretendard(to: .semiBold, size: 18)
        askLabel.textColor = .black
        view.addSubview(askLabel)
        askLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(26)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        emailLabel.text = "문의 제목"
        emailLabel.font = .pretendard(to: .regular, size: 14)
        emailLabel.textColor = .black
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(askLabel.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        emailTextField.font = .pretendard(to: .medium, size: 14)
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.centerY.equalTo(emailLabel.snp.centerY)
            make.leading.equalTo(emailLabel.snp.trailing).offset(13)
            make.height.equalTo(41)
        }
        
        contentLabel.text = "문의내용"
        contentLabel.font = .pretendard(to: .regular, size: 14)
        contentLabel.textColor = .black
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(26)
            make.leading.equalTo(view.snp.leading).offset(24)
        }

        askTextView.font = .pretendard(to: .medium, size: 14)
        askTextView.layer.cornerRadius = 9
        askTextView.layer.borderColor = UIColor.gray300.cgColor
        askTextView.layer.borderWidth = 1
        view.addSubview(askTextView)
        askTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(269)
        }
        
        sendButton.setTitle("전송하기", for: .normal)
        sendButton.backgroundColor = .mainBold
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.layer.cornerRadius = 10
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(49)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
        }
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendButtonTapped(_ sender: UIButton) {
        guard let title = emailTextField.text,
              let content = askTextView.text else {
            print("입력값이 잘못되었습니다.")
            return
        }
        
        ContactManager.shared.postContact(userId: KeyChainManager.loadMemberID(), inquiryTitle: title, inquiryText: content) { result in
            switch result {
            case .success(let contactResponse):
                print("요청 성공: \(contactResponse)")
                let modelMyPageVC = ModelMyPageViewController()
                self.navigationController?.pushViewController(modelMyPageVC, animated: true)
            case .failure(let error):
                print("요청 실패: \(error)")
            }
        }
    }
}

extension AskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "   여기에 내용을 작성해주세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "여기에 내용을 작성해주세요."
            textView.textColor = .gray300
        }
    }
}
