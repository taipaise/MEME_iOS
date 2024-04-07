//
//  RoleSelectionViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class RoleSelectionViewController: UIViewController {
    @IBOutlet weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var modelImageView: UIImageView!
    @IBOutlet weak var artistButton: UIButton!
    @IBOutlet weak var modelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    private var viewModel = RoleSelectionViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    private func setUI() {
        nextButton.layer.cornerRadius = 10
        nextButton.isEnabled = false
        progressBar.configure(progress: 0)
    }
}

// MARK: - binding
extension RoleSelectionViewController {
    private func bind() {
        let input = RoleSelectionViewModel.Input(
            modelTap: modelButton.rx.tap
                .asObservable(),
            artistTap: artistButton.rx.tap
                .asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.selectedType
            .subscribe(onNext: { [weak self] roleType in
                self?.setButtonImage(roleType: roleType)
            })
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
            .subscribe { [weak self] _ in
                let coordinator = SetProfileDetailCoordinator(navigationController: self?.navigationController)
                coordinator.start()
            }
            .disposed(by: disposeBag)
    }
}

extension RoleSelectionViewController {
    private func setButtonImage(roleType: RoleType?) {
        guard let roleType = roleType else {
            modelImageView.image = .roleDeselected
            artistImageView.image = .roleDeselected
            return
        }
           
        switch roleType {
        case .ARTIST:
            modelImageView.image = .roleDeselected
            artistImageView.image = .roleSelected
        case .MODEL:
            modelImageView.image = .roleSelected
            artistImageView.image = .roleDeselected
        }
    }
}
