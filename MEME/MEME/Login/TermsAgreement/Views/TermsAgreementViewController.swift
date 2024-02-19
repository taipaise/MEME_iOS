//
//  TermsAgreementViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class TermsAgreementViewController: UIViewController {
    
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var entireSelectButton: UIButton!
    @IBOutlet private weak var requiredButton1: UIButton!
    @IBOutlet private weak var requiredButton2: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    private lazy var requiredButtons = [requiredButton1, requiredButton2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }

    private func setUI() {
        nextButton.layer.cornerRadius = 10
        setNextButtonState()
        navigationBar.delegate = self
        navigationBar.configure(title: "")
    }
    
    @IBAction private func entireSelectButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        let state = sender.isSelected
        setButtonState(entireSelectButton, to: state)
        
        requiredButtons.forEach {
            guard let button = $0 else { return }
            setButtonState(button, to: state)
        }
        setNextButtonState()
    }
    
    @IBAction private func termButtonTapped(_ sender: UIButton) {
        setButtonState(sender, to: !sender.isSelected)
        setNextButtonState()
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        let nextVC = RoleSelectionViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }

    @IBAction func termDetailButtonTapped(_ sender: UIButton) {
        let termVC = TermDetailViewController()
        
        if sender.tag == 0 {
            termVC.configure(state: .persnalData)
        } else {
            termVC.configure(state: .service)
        }
        
        navigationController?.pushViewController(termVC, animated: true)
    }
    
    
}

extension TermsAgreementViewController {
    private func setButtonState(_ button: UIButton, to state: Bool) {
        switch state {
        case true:
            button.setImage(.icCheckFill, for: .normal)
        case false:
            button.setImage(.icCheckEmpty, for: .normal)
        }
        button.isSelected = state
    }
    
    private func setNextButtonState() {
        let isAllRequiredSelected = requiredButtons.allSatisfy { $0?.isSelected == true}
        nextButton.isEnabled = isAllRequiredSelected
        
        if isAllRequiredSelected {
            setButtonState(entireSelectButton, to: true)
            nextButton.backgroundColor = .mainBold
        } else {
            setButtonState(entireSelectButton, to: false)
            nextButton.backgroundColor = .gray300
        }
    }
}

extension TermsAgreementViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
