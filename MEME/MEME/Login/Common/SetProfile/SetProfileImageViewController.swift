//
//  SetProfileViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

final class SetProfileImageViewController: UIViewController {

    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var imageSelectButton1: UIButton!
    @IBOutlet private weak var imageSelectButton2: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!

    private var viewModel: SetProfileViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
   
    private func setUI() {
        progressBar.configure(progress: 1)
        nextButton.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        imageSelectButton2.layer.cornerRadius = imageSelectButton2.frame.height / 2
    }
    
    func configure(viewModel: SetProfileViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Binding
extension SetProfileImageViewController {
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = SetProfileViewModel.Input(
            skipTap: skipButton.rx.tap.asObservable(),
            nextTap: nextButton.rx.tap.asObservable()
        )
        
        
        let output = viewModel.transform(input)
        
        output.profileImage
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] profileImage in
                self?.profileImageView.image = profileImage
            }
            .disposed(by: disposeBag)
        
        output.navigation
            .subscribe { [weak self] navigationType in
                self?.navigate(type: navigationType)
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
        
        [imageSelectButton1, imageSelectButton2].forEach { imageSelectButton in
            imageSelectButton.rx.tap
                .subscribe { [weak self] _ in
                    guard let self = self else { return }
                    
                    let alert = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
                    let albumAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { _ in
                        viewModel.presentPHPicker(self)
                    }
                    let cameraAction = UIAlertAction(title: "사진 촬영", style: .default) { _ in
                        viewModel.presentImagePicker(self)
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(albumAction)
                    alert.addAction(cameraAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true)
                }
                .disposed(by: disposeBag)
        }
    }
}

extension SetProfileImageViewController {
        private func navigate(type: SetProfileViewModel.NavigationType) {
            guard let viewModel = viewModel else { return }
            let coordinator = SignUpCompletionCoordinator(navigationController: self.navigationController, profileInfo: viewModel.profileInfo)
            switch type {
            case .success:
                coordinator.start(isSuccess: true)
            case .fail:
                coordinator.start(isSuccess: false)
            case .none:
                break
            }
        }
    }
