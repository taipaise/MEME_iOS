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
    @IBOutlet private weak var kakaoLoginButton: UIButton!
    @IBOutlet private weak var appleLoginButton: UIButton!
    @IBOutlet private weak var memeLoginButton: UIButton!
    private let userDefaultManager = UserDefaultManager.shared
    private let authManager = AuthManager.shared
    private var viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

// MARK: - Binding
extension LoginViewController {
    private func bind() {
        let input = LoginViewModel.Input(
            socialLogin: .merge(
                kakaoLoginButton.rx.tap.asObservable().map { .KAKAO },
                appleLoginButton.rx.tap.asObservable().map { .APPLE }
            ),
            memeLogin: memeLoginButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.navigation.subscribe(onNext: { [weak self] navigationType in
            self?.navigate(type: navigationType)
        })
        .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    private func navigate(type: LoginViewModel.NavigationType) {
        switch type {
        case .snsSignUp:
            let coordinator = CommonSignUpCoordinator(navigationController: navigationController)
            coordinator.start()
        case .modelHome:
            let coordinator = ModelMainCoordinator(navigationController: navigationController)
            coordinator.start()
        case .artistHome:
            let coordinator = ArtistMainCoordinator(navigationController: navigationController)
            coordinator.start()
        case .memeLogin:
            let coordinator = MemeLoginCoordiantor(navigationController: navigationController)
            coordinator.start()
        case .none:
            break
        }
    }
}
