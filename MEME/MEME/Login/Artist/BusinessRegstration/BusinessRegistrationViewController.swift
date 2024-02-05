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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "회원가입")
        progressBar.configure(progress: 2)
        nextButton.layer.cornerRadius = 10
    }
    
    
    @IBAction private func verifyButtonTapped(_ sender: Any) {
        guard
            let id = numberTextField.text,
            let name = nameTextField.text,
            let date = dateTextField.text
        else {
            return
        }
        
        let manager = BusinessIDVerificationManager.shared
        manager.verifyId(
            id: id,
            name: name,
            date: date
        ) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        let nextVC = RegistrationCompletionViewController()
        nextVC.configure(isArtist: true)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension BusinessRegistrationViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
