//
//  TermsAgreementViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TermsAgreementViewController: UIViewController {
    
    @IBOutlet private weak var entireSelectButton: UIButton!
    @IBOutlet private weak var fitstAgreeButton: UIButton!
    @IBOutlet private weak var secondAgreeButton: UIButton!
    @IBOutlet private var termDetailButtons: [UIButton]!
    @IBOutlet private weak var nextButton: UIButton!
    private lazy var requiredButtons = [fitstAgreeButton, secondAgreeButton]
    private var viewModel = TermsAgreementViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    private func setUI() {
        nextButton.layer.cornerRadius = 10
    }
}

// MARK: - Binding
extension TermsAgreementViewController {
    private func bind() {
        let input = TermsAgreementViewModel.Input(
            entireButtonTap: entireSelectButton.rx.tap
                .map {[weak self] in self?.entireSelectButton.tag ?? 0}
                .asObservable(),
            firstAgreementButtonTap: fitstAgreeButton.rx.tap
                .map {[weak self] in self?.fitstAgreeButton.tag ?? 1}
                .asObservable(),
            secondAgreementButtonTap: secondAgreeButton.rx.tap
                .map {[weak self] in self?.secondAgreeButton.tag ?? 2}
                .asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.entireAgreeButtonState
            .subscribe { [weak self] state in
                if state {
                    self?.entireSelectButton.setImage(.icCheckFill, for: .normal)
                } else {
                    self?.entireSelectButton.setImage(.icCheckEmpty, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        output.firstAgreeButtonState
            .subscribe { [weak self] state in
                if state {
                    self?.fitstAgreeButton.setImage(.icCheckFill, for: .normal)
                } else {
                    self?.fitstAgreeButton.setImage(.icCheckEmpty, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        output.secondAgreeButtonState
            .subscribe { [weak self] state in
                if state {
                    self?.secondAgreeButton.setImage(.icCheckFill, for: .normal)
                } else {
                    self?.secondAgreeButton.setImage(.icCheckEmpty, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        output.nextButtonState
            .subscribe { [weak self] state in
                self?.nextButton.isEnabled = state
                if state {
                    self?.nextButton.backgroundColor = .mainBold
                } else {
                    self?.nextButton.backgroundColor = .gray300
                }
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let coordinator = RoleSelectionCoordinator(navigationController: self?.navigationController)
                coordinator.start()
            })
            .disposed(by: disposeBag)
        
        termDetailButtons.forEach { detailButton in
            detailButton.rx.tap
                .subscribe { [weak self] _ in
                    let coordinator = TermDetailCoordinator(presentingVC: self)
                    guard let termType = TermsData(rawValue: detailButton.tag) else { return }
                    coordinator.start(termType: termType)
                }
                .disposed(by: disposeBag)
        }
    }
}
