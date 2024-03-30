//
//  AskViewController.swift
//  MEME
//
//  Created by 임아영 on 1/29/24.
//

import UIKit

class AskViewController: UIViewController {
    
    let askLabel = UILabel()
    
    let emailLabel = UILabel()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.borderStyle = .none
        tf.layer.cornerRadius = 9
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(named: "Gray300")?.cgColor
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
        
        configureUI()
        
        self.tabBarController?.tabBar.isHidden = true
        
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
        
        askLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        askTextView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(askLabel)
        askLabel.text = "문의할 내용을 남겨주세요."
        askLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        NSLayoutConstraint.activate([
            askLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            askLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        view.addSubview(emailLabel)
        emailLabel.text = "문의 제목"
        emailLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: askLabel.bottomAnchor, constant: 24),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        view.addSubview(emailTextField)
        emailTextField.font = UIFont(name: "Pretendard-Medium", size: 14)
        NSLayoutConstraint.activate([
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 13),
            emailTextField.heightAnchor.constraint(equalToConstant: 41)
        ])
        
        view.addSubview(contentLabel)
        contentLabel.text = "문의내용"
        contentLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 26),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        view.addSubview(askTextView)
        askTextView.text = "   여기에 내용을 작성해주세요."
        askTextView.textColor = UIColor.gray300
        askTextView.font = UIFont(name: "Pretendard-Medium", size: 14)
        askTextView.layer.cornerRadius = 9
        
        askTextView.delegate = self
        
        askTextView.layer.borderColor = UIColor.gray300.cgColor
        askTextView.layer.borderWidth = 1
        NSLayoutConstraint.activate([
            askTextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            askTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            askTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            askTextView.heightAnchor.constraint(equalToConstant: 269)
        ])
        
        view.addSubview(sendButton)
        sendButton.setTitle("전송하기", for: .normal)
        sendButton.backgroundColor = UIColor(named: "MainBold")
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 49),
            sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
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
            case .failure(let error):
                print("요청 실패: \(error)")
            }
        }
    }
}

extension AskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray300 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "여기에 내용을 작성해주세요."
            textView.textColor = UIColor.gray300
        }
    }
}
