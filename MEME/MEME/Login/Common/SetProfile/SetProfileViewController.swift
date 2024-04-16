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

final class SetProfileViewController: UIViewController {

    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var imageSelectButton1: UIButton!
    @IBOutlet private weak var imageSelectButton2: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var nickNameTextField: UITextField!
    @IBOutlet private weak var noticeLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var verificationButton: UIButton!
    private var viewModel: SetProfileViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupDismissKeyboardOnTapGesture()
        bind()
    }
   
    private func setUI() {
        progressBar.configure(progress: 1)
        nextButton.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        imageSelectButton2.layer.cornerRadius = imageSelectButton2.frame.height / 2
        verificationButton.layer.borderWidth = 1
        verificationButton.layer.borderColor = UIColor.mainBold.cgColor
        verificationButton.layer.cornerRadius = 10
    }
    
    func configure(viewModel: SetProfileViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Binding
extension SetProfileViewController {
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = SetProfileViewModel.Input(
            name: nameTextField.rx.text.orEmpty.asObservable(),
            nickname: nickNameTextField.rx.text.orEmpty.asObservable(),
            verifyTap: verificationButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.profileImage
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] profileImage in
                self?.profileImageView.image = profileImage
            }
            .disposed(by: disposeBag)
        
        output.nickNameStatus
            .subscribe(onNext: { [weak self] nickNameStatus in
                self?.setNoticeLabel(nickNameStatus)
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
        
        nextButton.rx.tap
            .subscribe { [weak self] _ in
                let role = viewModel.roleType
                
                switch role {
                case .ARTIST:
                    let coordinator = ArtistSignUpCoordinator(navigationController: self?.navigationController)
                    coordinator.start()
                case .MODEL:
                    let coordinator = ModelSignUpCoordinator(
                        navigationController: self?.navigationController,
                        profileInfo: viewModel.profileInfo)
                    coordinator.start()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SetProfileViewController {
    private func setNoticeLabel(_ status: NickNameStatus?) {
        guard let status = status else {
            noticeLabel.isHidden = true
            return
        }
       
        noticeLabel.isHidden = false
        noticeLabel.text = status.message
        noticeLabel.textColor = status.textColor
    }
}

extension SetProfileViewController {
    func setupDismissKeyboardOnTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
