//
//  RoleSelectionViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class RoleSelectionViewController: UIViewController {

    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var modelImageView: UIImageView!
    @IBOutlet weak var artistButton: UIButton!
    @IBOutlet weak var modelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    private lazy var registrationImageViews = [artistImageView, modelImageView]
    private lazy var registrationButtons = [artistButton, modelButton]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "회원가입")
        nextButton.layer.cornerRadius = 10
        nextButton.isEnabled = false
        progressBar.configure(progress: 0)
    }
    
    private func manageSelected() {
        registrationImageViews.enumerated().forEach { index, imageView in
            guard let isSelected = registrationButtons[index]?.isSelected else { return }
            if isSelected {
                imageView?.image = .roleSelected
            } else {
                imageView?.image = .roleDeselected
            }
        }
        setNextButton()
    }
    
    private func setNextButton() {
        let isEnabled = artistButton.isSelected || modelButton.isSelected
        nextButton.isEnabled = isEnabled
        
        if isEnabled {
            nextButton.backgroundColor = .mainBold
        } else {
            nextButton.backgroundColor = .gray300
        }
    }
    
    @IBAction private func roleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {   
            registrationButtons.forEach {
                if sender.tag != $0?.tag {
                    $0?.isSelected = false
                }
            }
        }
        manageSelected()
    }
    
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        let isModeSelected = modelButton.isSelected
        let nextVC = SetProfileViewController()
        let isArtist = artistButton.isSelected
        nextVC.configure(isArtist: isArtist)
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension RoleSelectionViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
