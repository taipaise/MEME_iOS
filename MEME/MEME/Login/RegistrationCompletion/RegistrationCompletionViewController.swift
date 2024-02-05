//
//  RegistrationCompletionViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class RegistrationCompletionViewController: UIViewController {

    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var completionButton: UIButton!
    private var isArtist = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func configure(isArtist: Bool) {
        self.isArtist = isArtist
    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        
        let nextVC = isArtist ? SetBusinessInfoViewController() : ModelTabBarController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setUI() {
        navigationBar.configure(title: "회원가입")
        completionButton.layer.cornerRadius = 10
    }

}
