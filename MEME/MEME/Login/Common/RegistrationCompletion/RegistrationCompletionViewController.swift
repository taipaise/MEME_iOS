//
//  RegistrationCompletionViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class RegistrationCompletionViewController: UIViewController {

    @IBOutlet private weak var completionButton: UIButton!
    @IBOutlet private weak var completionLabel: UILabel!
    
    private var isArtist = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        if let nickname = KeyChainManager.read(forkey: .nickName) {
            completionLabel.text = "\(nickname)님, 회원가입이 완료되었습니다!"
        }
    }
    
    func configure(isArtist: Bool) {
        self.isArtist = isArtist
    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        
        let nextVC = isArtist ? SetBusinessInfoViewController() : ModelTabBarController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
    }
    
    private func setUI() {
        completionButton.layer.cornerRadius = 10
    }
}
