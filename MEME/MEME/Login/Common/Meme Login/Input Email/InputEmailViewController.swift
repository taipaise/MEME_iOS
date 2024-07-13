//
//  FindAccountViewController.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InputEmailViewController: UIViewController {
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .semiBold, size: 18)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.font = .pretendard(to: .medium, size: 14)
        view.textColor = .black
        view.addLeftPadding(padding: 10)
        view.borderStyle = .none
        view.layer.borderColor = UIColor.gray400.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var invalidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
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
    
    private let viewModel: InputEmailViewModel
    private var disposeBag = DisposeBag()
    
    init(mode: FindAccountMode) {
        viewModel = InputEmailViewModel(mode)
        super.init(nibName: nil, bundle: nil)
        updateUI(mode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addSubviews()
        makeConstraints()
        bindView()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setUI() {
        view.backgroundColor = .white
        textField.delegate = self
    }
}

// MARK: - layout configuration
extension InputEmailViewController {
    private func addSubviews() {
        view.addSubViews([
            descriptionLabel,
            textField,
            invalidLabel,
            nextButton
        ])
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            $0.leading.equalToSuperview().offset(24)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(49)
        }
        
        invalidLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(9)
            $0.height.equalTo(49)
        }
    }
}

// MARK: - binding
extension InputEmailViewController {
    private func bindView() {
        nextButton.rx.tap
            .withUnretained(self)
            .subscribe { (self, _) in
                // TODO: - 임시 인증 코드
                let coordinator = InputVerificationCodeCoordinator(
                    navigationController: self.navigationController,
                    code: "0000"
                )
                coordinator.start()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = InputEmailViewModel.Input(
            inputInfo: textField.rx.text.asObservable(),
            requestFind: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.userInfoStatus
            .withUnretained(self)
            .subscribe { (self, status) in
                switch status {
                case .networkError:
                    // TODO: - 네트워크 에러 처리
                    print("network error")
                case .valid:
                    self.invalidLabel.isHidden = true
                case .invalid:
                    self.invalidLabel.isHidden = false
                case .none:
                    self.invalidLabel.isHidden = true
                }
            }
            .disposed(by: disposeBag)
    }
}
// MARK: - UI
extension InputEmailViewController {
    private func updateUI(_ mode: FindAccountMode) {
        descriptionLabel.text = mode.description
        textField.placeholder = mode.placeholder
        switch mode {
        case .findEmail:
            invalidLabel.text = "가입되지 않은 닉네임입니다."
        case .findPassword:
            invalidLabel.text = "가입되지 않은 이메일입니다."
        }
    }
}

// MARK: - Textfeild delegate
extension InputEmailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            nextButton.isEnabled = !text.isEmpty
            nextButton.backgroundColor = !text.isEmpty ? .mainBold : .gray400
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .gray400
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
