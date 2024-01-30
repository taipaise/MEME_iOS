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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    private func setUI() {
        navigationBar.configure(title: "회원가입")
        completionButton.layer.cornerRadius = 10
    }

}
