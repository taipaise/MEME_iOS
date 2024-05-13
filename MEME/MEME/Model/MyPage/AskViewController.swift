//
//  AskViewController.swift
//  MEME
//
//  Created by 임아영 on 1/29/24.
//

import UIKit
import SnapKit

class AskViewController: UIViewController, UITextViewDelegate {
        
    private lazy var askLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .semiBold, size: 18)
        label.text = "문의할 내용을 남겨주세요."
        label.textColor = .black
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 14)
        label.text = "문의 제목"
        label.textColor = .black
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.font = .pretendard(to: .medium, size: 14)
        tf.borderStyle = .none
        tf.layer.cornerRadius = 9
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray300.cgColor
        tf.placeholder = "제목을 입력해주세요."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: tf.frame.height))
        tf.leftViewMode = .always
        return tf
    }()

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 14)
        label.text = "문의 내용"
        label.textColor = .black
        return label
    }()

    private lazy var askTextView: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = .white
        textview.font = .pretendard(to: .medium, size: 14)
        textview.layer.cornerRadius = 9
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor.gray300.cgColor
        textview.placeholder = "여기에 내용을 작성해주세요."
        return textview
    }()

    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("전송하기", for: .normal)
        btn.backgroundColor = .mainBold
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        askTextView.delegate = self
        addSubviews()
        makeConstraints()
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
    
    func addSubviews() {
        view.addSubview(askLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(contentLabel)
        view.addSubview(askTextView)
        view.addSubview(sendButton)
    }
    
    func makeConstraints() {
        askLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(26)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(askLabel.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.centerY.equalTo(emailLabel.snp.centerY)
            make.leading.equalTo(emailLabel.snp.trailing).offset(13)
            make.height.equalTo(41)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(26)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        askTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(269)
        }
        
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.centerX.equalTo(view)
            make.height.equalTo(49)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.updatePlaceholderVisibility()
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

extension UITextView {
    
    private static var placeholderLabelAssocKey: UInt8 = 0

    private var placeholderLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &UITextView.placeholderLabelAssocKey) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &UITextView.placeholderLabelAssocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @IBInspectable var placeholder: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if placeholderLabel == nil {
                let label = UILabel()
                label.text = newValue
                label.numberOfLines = 0
                label.textColor = .gray300
                label.font = self.font
                label.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(label)
                self.placeholderLabel = label

                label.snp.makeConstraints { make in
                    make.top.equalTo(self).offset(8)
                    make.left.equalTo(self).offset(5)
                    make.right.equalTo(self).offset(-5)
                }
            } else {
                placeholderLabel?.text = newValue
            }

            placeholderLabel?.isHidden = !self.text.isEmpty
        }
    }

    func updatePlaceholderVisibility() {
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
}
