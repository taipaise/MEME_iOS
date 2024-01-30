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
    @IBOutlet private weak var textField: UITextField!
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
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        let nextVC = SetBusinessInfoViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension BusinessRegistrationViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
