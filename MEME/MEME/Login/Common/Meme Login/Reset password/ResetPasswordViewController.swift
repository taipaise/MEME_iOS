//
//  ResetPasswordViewController.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ResetPasswordViewController: UIViewController {
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "메메에서 새로 사용할\n비밀번호를 입력해주세요"
        label.font = .pretendard(to: .semiBold, size: 18)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "비밀번호를 입력해주세요"
        view.isSecureTextEntry = true
        view.font = .pretendard(to: .medium, size: 14)
        view.textColor = .black
        view.addLeftPadding(padding: 10)
        view.borderStyle = .none
        view.layer.borderColor = UIColor.gray400.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var verificationTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "비밀번호를 한번 더 입력해주세요"
        view.isSecureTextEntry = true
        view.font = .pretendard(to: .medium, size: 14)
        view.textColor = .black
        view.addLeftPadding(padding: 10)
        view.borderStyle = .none
        view.layer.borderColor = UIColor.gray400.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray400
        label.text = "영문,숫자,특수기호 조합 8~20자로 설정해주세요"
        label.font = .pretendard(to: .regular, size: 12)
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.backgroundColor = .gray400
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    private let viewModel = ResetPasswordViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        setUI()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setUI() {
        view.backgroundColor = .white
        passwordTextField.delegate = self
        verificationTextField.delegate = self
    }
    
    private func setNextButton(_ isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
        if isEnabled {
            nextButton.backgroundColor = .mainBold
        } else {
            nextButton.backgroundColor = .gray400
        }
    }
}

extension ResetPasswordViewController {
    private func addSubviews() {
        view.addSubViews([
            descriptionLabel,
            passwordTextField,
            verificationTextField,
            resultLabel,
            nextButton
        ])
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            $0.leading.equalToSuperview().offset(24)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(49)
        }
        
        verificationTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(49)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(verificationTextField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(9)
            $0.height.equalTo(49)
        }
    }
}

// MARK: - Binding
extension ResetPasswordViewController {
    private func bindViewModel() {
        let input = ResetPasswordViewModel.Input(
            inputPassword: passwordTextField.rx.text.asObservable(),
            inputVerification: verificationTextField.rx.text.asObservable(),
            requestReset: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.passwordState
            .withUnretained(self)
            .subscribe { (self, state) in
                switch state {
                case .invalid:
                    self.resultLabel.text = "영문,숫자,특수기호 조합 8~20자로 설정해주세요!"
                    self.resultLabel.textColor = .red
                    self.setNextButton(false)
                case .different:
                    self.resultLabel.text = "입력한 비밀번호와 다릅니다"
                    self.resultLabel.textColor = .red
                    self.setNextButton(false)
                case .valid:
                    self.resultLabel.text = "유효한 비밀번호입니다"
                    self.resultLabel.textColor = .subBlue
                    self.setNextButton(true)
                case .none:
                    self.resultLabel.text = "영문,숫자,특수기호 조합 8~20자"
                    self.resultLabel.textColor = .gray400
                    self.setNextButton(false)
                }
            }
            .disposed(by: disposeBag)
        
        output.requestCompleted
            .withUnretained(self)
            .subscribe { (self, _) in
                let alert = UIAlertController(
                    title: nil,
                    message: "비밀번호 재설정이 완료되었습니다!",
                    preferredStyle: .alert
                )
                let confirm = UIAlertAction(
                    title: "확인",
                    style: .cancel
                ) { _ in
                    guard
                        let viewControllers = self.navigationController?.viewControllers,
                        viewControllers.count >= 2
                    else {
                        self.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                    
                    let memeLoginViewController = viewControllers[1]
                    self.navigationController?.popToViewController(memeLoginViewController, animated: true)
                }
                alert.addAction(confirm)
                self.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TextField Delegate
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
