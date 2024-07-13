//
//  MemeSignUpViewController.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MemeSignUpViewController: UIViewController {
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .semiBold, size: 14)
        label.text = "이메일"
        label.textColor = .black
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "이메일을 입력해주세요"
        view.font = .pretendard(to: .medium, size: 14)
        return view
    }()
    
    private lazy var verificationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainBold
        button.tintColor = .white
        button.setTitle("인증코드 요청", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 12)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var verificationCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드 입력"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 14)
        return label
    }()
    
    private lazy var verificationCodeTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "인증코드를 입력해주세요"
        view.font = .pretendard(to: .medium, size: 14)
        return view
    }()
    
    private lazy var verificationCodeResultLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드 일치"
        label.textColor = .gray400
        label.font = .pretendard(to: .regular, size: 12)
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .checkGray
        return view
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "3:00"
        label.textColor = .mainBold
        label.font = .pretendard(to: .regular, size: 12)
        return label
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 14)
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "비밀번호를 입력해주세요"
        view.font = .pretendard(to: .medium, size: 14)
        return view
    }()
    
    private lazy var passwordVerificationTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "비밀번호를 한 번 더 입력해주세요"
        view.font = .pretendard(to: .medium, size: 14)
        
        return view
    }()
    
    private lazy var passwordResultLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 12)
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.tintColor = .white
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .gray400
        button.layer.cornerRadius = 10
        return button
    }()
    private var timer: Timer?
    private let viewModel = MemeSignUpViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        setUI()
        bindView()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setUI() {
        view.backgroundColor = .white
        [
            emailTextField,
            verificationCodeTextField,
            passwordTextField,
            passwordVerificationTextField
        ].forEach {
            $0.borderStyle = .none
            $0.layer.borderColor = UIColor.gray400.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
            $0.textColor = .black
            $0.delegate = self
            $0.addLeftPadding(padding: 10)
        }
    }
}

// MARK: - layout configuration
extension MemeSignUpViewController {
    private func addSubviews() {
        view.addSubViews([
            emailLabel,
            emailTextField,
            verificationButton,
            verificationCodeLabel,
            verificationCodeTextField,
            verificationCodeResultLabel,
            checkImageView,
            timerLabel,
            passwordLabel,
            passwordTextField,
            passwordVerificationTextField,
            passwordResultLabel,
            nextButton
        ])
    }
    
    private func makeConstraints() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            $0.leading.equalToSuperview().offset(24)
        }
        
        verificationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.width.equalTo(90)
            $0.height.equalTo(49)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(verificationButton.snp.leading).offset(-8)
            $0.height.equalTo(49)
        }
        
        verificationCodeLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        
        verificationCodeTextField.snp.makeConstraints {
            $0.top.equalTo(verificationCodeLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(49)
        }
        
        verificationCodeResultLabel.snp.makeConstraints {
            $0.top.equalTo(verificationCodeTextField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalTo(verificationCodeResultLabel)
            $0.leading.equalTo(verificationCodeResultLabel.snp.trailing).offset(4)
            $0.width.equalTo(16)
            $0.height.equalTo(11)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalTo(verificationCodeTextField)
            $0.trailing.equalTo(verificationCodeTextField.snp.trailing).inset(9)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(verificationCodeResultLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(49)
        }
        
        passwordVerificationTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(49)
        }
        
        passwordResultLabel.snp.makeConstraints {
            $0.top.equalTo(passwordVerificationTextField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(9)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(49)
        }
    }
}

// MARK: - UI
extension MemeSignUpViewController {
    private func setVerficationButton(_ state: MemeSignUpViewModel.FetchVerificationCodeState) {
        switch state {
        case .none:
            self.verificationButton.isEnabled = false
            self.verificationButton.backgroundColor = .gray400
            self.timerLabel.isHidden = true
        case .canRequest:
            self.verificationButton.isEnabled = true
            self.verificationButton.backgroundColor = .mainBold
            self.timerLabel.isHidden = true
        case .failure:
            self.timerLabel.isHidden = true
            break
        case .success:
            self.emailTextField.isEnabled = false
            self.verificationButton.setTitle("코드 재전송", for: .normal)
            self.timerLabel.isHidden = false
        }
    }
    
    private func setVerificationResultLabel(_ isValid: Bool) {
        if isValid {
            self.verificationCodeResultLabel.textColor = .subBlue
            self.checkImageView.image = .checkBlue
            self.nextButton.backgroundColor = .mainBold
            self.nextButton.isEnabled = true
        } else {
            self.verificationCodeResultLabel.textColor = .gray400
            self.checkImageView.image = .checkGray
            self.nextButton.backgroundColor = .gray400
            self.nextButton.isEnabled = false
        }
    }
    
    private func setPasswordResultLabel(_ state: MemeSignUpViewModel.PasswordState) {
        switch state {
        case .invalid:
            self.passwordResultLabel.text = "영문,숫자,특수기호 조합 8~20자로 설정해주세요!"
            self.passwordResultLabel.textColor = .red
        case .different:
            self.passwordResultLabel.text = "입력한 비밀번호와 다릅니다"
            self.passwordResultLabel.textColor = .red
        case .valid:
            self.passwordResultLabel.text = "유효한 비밀번호입니다"
            self.passwordResultLabel.textColor = .subBlue
        case .none:
            self.passwordResultLabel.text = "영문,숫자,특수기호 조합 8~20자로 설정해주세요!"
            self.passwordResultLabel.textColor = .gray400
        }
    }
}

// MARK: - Biding
extension MemeSignUpViewController {
    private func bindView() {
        nextButton.rx.tap
            .withUnretained(self)
            .subscribe { (self, _) in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = MemeSignUpViewModel.Input(
            inputEmail: emailTextField.rx.text.asObservable(),
            requestCode: verificationButton.rx.tap.asObservable(),
            inputCode: verificationCodeTextField.rx.text.asObservable(),
            inputPassword: passwordTextField.rx.text.asObservable(),
            inputPasswordVerfication: passwordVerificationTextField.rx.text.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.fetchVerificationState
            .withUnretained(self)
            .subscribe { (self, state) in
                self.setVerficationButton(state)
            }
            .disposed(by: disposeBag)
        
        output.verificationCodeState
            .withUnretained(self)
            .subscribe { (self, state) in
                self.setVerificationResultLabel(state == .valid)
                if state == .retry {
                    self.verificationCodeTextField.text = nil
                    self.startTimer()
                }
            }
            .disposed(by: disposeBag)
        
        output.passwordState
            .withUnretained(self)
            .subscribe { (self, state) in
                self.setPasswordResultLabel(state)
            }
            .disposed(by: disposeBag)
        
        output.isAllValid
            .withUnretained(self)
            .subscribe { (self, isValid) in
                self.nextButton.isEnabled = isValid
                self.nextButton.backgroundColor = isValid ? .mainBold : .gray400
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Timer
extension MemeSignUpViewController {
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
        
        timerLabel.text = viewModel
            .leftTime
            .value
            .toFormattedTime
    }
    
    @objc private func updateTime() {
        let leftTime = viewModel.leftTime.value
        guard leftTime >= 0 else {
            timer?.invalidate()
            timer = nil
            return
        }

        if leftTime >= 0 {
            timerLabel.text = leftTime.toFormattedTime
        }
        
        viewModel.reduceTime()
    }
}

// MARK: - textField Delegates
extension MemeSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

fileprivate extension Int {
    var toFormattedTime: String {
        let minutes = self / 60
        let remainingSeconds = self % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
