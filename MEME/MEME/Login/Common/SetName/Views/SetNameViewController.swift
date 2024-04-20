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
        tf.font = .pretendard(to: .regular, size: 14)
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(
            string: "실명만 입력 가능합니다.",
            attributes: [.foregroundColor: UIColor.gray400])
        return tf
    }()
    private lazy var nickNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.attributedPlaceholder = NSAttributedString(
            string: "닉네임은 최대 15자 작성 가능합니다.",
            attributes: [.foregroundColor: UIColor.gray400])
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
    private lazy var divideLine1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray500
        return view
    }()
    private lazy var divideLine2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray500
        return view
    }()
    private var viewModel: SetNameViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        makeConstraints()
        setUI()
        bind()
    }
    
    func configure(viewModel: SetNameViewModel) {
        self.viewModel = viewModel
    }
    
    private func setUI() {
        view.backgroundColor = .white
        navigationItem.title = "회원가입"
        progressBar.configure(progress: 1)
        
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(to: .semiBold, size: 16),
            .foregroundColor: UIColor.black
        ]
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(to: .medium, size: 16),
            .foregroundColor: UIColor.black
        ]
        
        let nameString = NSMutableAttributedString(string: "이름을 입력해주세요", attributes: regularAttributes)
        let nickNameString = NSMutableAttributedString(string: "닉네임을 입력해주세요", attributes: regularAttributes)
        nameString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 2))
        nickNameString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 3))
        
        nameLabel.attributedText = nameString
        nickNameLabel.attributedText = nickNameString
        
        nextButton.layer.cornerRadius = 10
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
            nextButton,
            divideLine1,
            divideLine2
        ]
        
        view.addSubViews(subViews)
    }
    
    private func makeConstraints() {
        progressBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(2)
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
        
        divideLine1.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(nameTextField.snp.bottom)
            $0.height.equalTo(1)
        }
        
        divideLine2.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(nickNameTextField.snp.bottom)
            $0.height.equalTo(1)
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
