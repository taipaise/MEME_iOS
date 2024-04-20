//
//  SetNameViewController.swift
//  MEME
//
//  Created by 이동현 on 4/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SetNameViewController: UIViewController {
    private lazy var progressBar = RegisterProgressBar()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        return label
    }()
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        return label
    }()
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.placeholder = "실명만 입력 가능합니다."
        tf.font = .pretendard(to: .regular, size: 14)
        tf.textColor = .black
        return tf
    }()
    private lazy var nickNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.placeholder = "닉네임은 최대 15자 작성 가능합니다."
        tf.font = .pretendard(to: .regular, size: 14)
        tf.textColor = .black
        return tf
    }()
    private lazy var nickNameNoticeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .medium, size: 12)
        label.textColor = .black
        return label
    }()
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .pretendard(to: .medium, size: 14)
        button.backgroundColor = .mainBold
        return button
    }()
    private lazy var nickNameVerifyButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setTitle("중복확인", for: .normal)
        button.backgroundColor = .mainBold
        return button
    }()
    private var viewModel: SetNameViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        makeConstraints()
        setUI()
    }
    
    func configure(viewModel: SetNameViewModel) {
        self.viewModel = viewModel
    }
    
    private func setUI() {
        progressBar.configure(progress: 1)
        
        [nameTextField, nickNameTextField].forEach {
            let bottomLayer = CALayer()
            bottomLayer.frame = CGRect(
                x: 0,
                y: $0.frame.size.height - 1,
                width: $0.frame.size.width,
                height: 1)
            bottomLayer.backgroundColor = UIColor.gray500.cgColor
            $0.layer.addSublayer(bottomLayer)
        }
    }

}

// MARK: - Set Layout
extension SetNameViewController {
    private func addSubViews() {
        let subViews = [
            progressBar,
            nameLabel,
            nameTextField,
            nickNameLabel,
            nickNameTextField,
            nickNameNoticeLabel,
            nickNameVerifyButton,
            nextButton
        ]
        
        view.addSubViews(subViews)
    }
    
    private func makeConstraints() {
        progressBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(2)
            $0.height.equalTo(3)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(progressBar.snp.bottom).offset(42)
            $0.height.equalTo(19)
        }
        
        nameTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(nameLabel.snp.bottom).offset(17)
            $0.height.equalTo(33)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(nameTextField.snp.bottom).offset(70)
            $0.height.equalTo(19)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(17)
            $0.height.equalTo(33)
        }
        
        nickNameVerifyButton.snp.makeConstraints {
            $0.trailing.equalTo(nickNameTextField)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
            $0.centerY.equalTo(nickNameTextField)
        }
        
        nickNameNoticeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(6)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(9)
            $0.height.equalTo(49)
        }
    }
}

// MARK: - Binding
extension SetNameViewController {
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = SetNameViewModel.Input(
            name: nameTextField.rx.text.orEmpty.asObservable(),
            nickname: nickNameTextField.rx.text.orEmpty.asObservable(),
            verifyTap: nickNameVerifyButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input)
        
        output.nickNameStatus
            .subscribe(onNext: { [weak self] nickNameStatus in
                self?.setNickNameNoticeLabel(nickNameStatus)
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
                let coordinator = SetProfileImageCoordinator(navigationController: self?.navigationController, profileInfo: viewModel.profileInfo)
                coordinator.start()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Update UI
extension SetNameViewController {
    private func setNickNameNoticeLabel(_ status: NickNameStatus?) {
        guard let status = status else {
            nickNameNoticeLabel.isHidden = true
            return
        }
       
        nickNameNoticeLabel.isHidden = false
        nickNameNoticeLabel.text = status.message
        nickNameNoticeLabel.textColor = status.textColor
    }
}
