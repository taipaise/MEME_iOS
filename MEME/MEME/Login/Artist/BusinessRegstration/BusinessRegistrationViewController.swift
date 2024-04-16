//
//  BusinessRegistrationViewController.swift
//  MEME
//
//  Created by 이동현 on 1/17/24.
//

import UIKit

final class BusinessRegistrationViewController: UIViewController {

    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var numberTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    private var profileInfoBuilder: ProfileInfoBuilder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupDismissKeyboardOnTapGesture()
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "회원가입")
        progressBar.configure(progress: 2)
        nextButton.layer.cornerRadius = 10
    }
    
    func configure(builder: ProfileInfoBuilder) {
        profileInfoBuilder = builder
    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "알림", message: "모든 항목을 입력해주세요", preferredStyle: .alert)
        
        let failAlert = UIAlertController(title: "알림", message: "유효한 사업자 등록번호가 아닙니다.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(cancelAction)
        failAlert.addAction(cancelAction)
        
        guard
            let id = numberTextField.text,
            let name = nameTextField.text,
            let date = dateTextField.text
        else {
            present(alert, animated: true)
            return
        }
        
        let manager = BusinessIDVerificationManager.shared
        manager.verifyId(
            id: id,
            name: name,
            date: date
        ) {
            [weak self] result in
            switch result {
            case .success(let data):
                let nextVC = RegistrationCompletionViewController()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            case .failure(let error):
                self?.present(failAlert, animated: true)
                print(error.localizedDescription)
            }
        }
    }
    
}

extension BusinessRegistrationViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension BusinessRegistrationViewController {
    func setupDismissKeyboardOnTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
