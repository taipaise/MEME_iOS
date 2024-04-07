//
//  LoginViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    private let userDefaultManager = UserDefaultManager.shared
    private let authManager = AuthManager.shared
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
