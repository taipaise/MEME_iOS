//
//  RegistrationCompletionViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class RegistrationCompletionViewController: UIViewController {

    @IBOutlet private weak var completionButton: UIButton!
    @IBOutlet private weak var completionLabel: UILabel!
    var viewModel: RegisterCompletionViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    private func setUI() {
        completionButton.layer.cornerRadius = 10
        navigationItem.title = "회원가입"
    }
}

// MARK: - Binding
extension RegistrationCompletionViewController {
    private func bind() {
        viewModel?.nickName
            .subscribe(onNext: { [weak self] name in
                self?.completionLabel.text = "\(name)님, 회원가입이 완료되었습니다!"
            })
            .disposed(by: disposeBag)
        
        completionButton.rx.tap
            .subscribe { [weak self] _ in
                guard let type = self?.viewModel?.role else { return }
                self?.navigate(type: type)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - navigate
extension RegistrationCompletionViewController {
    private func navigate(type: RoleType) {
        switch type {
        case .MODEL:
            let coordinator = ModelMainCoordinator(navigationController: navigationController)
            coordinator.start()
        case .ARTIST:
            let coordinator = ArtistMainCoordinator(navigationController: navigationController)
            coordinator.start()
        }
    }
}
