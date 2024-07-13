//
//  InputVerificationCodeViewController.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa

final class InputVerificationCodeViewController: UIViewController {
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일로 발송된\n인증코드를 입력해주세요"
        label.font = .pretendard(to: .semiBold, size: 18)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.placeholder = "인증코드를 입력해주세요"
        view.font = .pretendard(to: .medium, size: 14)
        view.textColor = .black
        view.addLeftPadding(padding: 10)
        view.borderStyle = .none
        view.layer.borderColor = UIColor.gray400.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainBold
        label.text = "3:00"
        label.font = .pretendard(to: .regular, size: 12)
        return label
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray400
        label.text = "인증코드 일치"
        label.font = .pretendard(to: .regular, size: 12)
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let view = UIImageView()
        view.image = .checkGray
        view.contentMode = .scaleAspectFit
        return view
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
    // TODO: - 임시 재전송 버튼
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("재전송", for: .normal)
        button.backgroundColor = .gray400
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.tintColor = .black
        return button
    }()
    private var timer: Timer?
    private let viewModel: InputVerificationCodeViewModel
    private var disposeBag = DisposeBag()
    
    init(code: String) {
        viewModel = InputVerificationCodeViewModel(code: code)
        super.init(nibName: nil, bundle: nil)
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
        startTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setUI() {
        view.backgroundColor = .white
        textField.delegate = self
    }
    
    private func updateUI(verificationState: InputVerificationCodeViewModel.VerificationState) {
        if verificationState == .valid {
            resultLabel.textColor = .subBlue
            checkImageView.image = .checkBlue
            nextButton.backgroundColor = .mainBold
            nextButton.isEnabled = true
        } else {
            resultLabel.textColor = .gray400
            checkImageView.image = .checkGray
            nextButton.backgroundColor = .gray400
            nextButton.isEnabled = false
        }
        
        if verificationState == .retry {
            startTimer()
        }
    }
}

// MARK: - layout configuration
extension InputVerificationCodeViewController {
    private func addSubviews() {
        view.addSubViews([
            descriptionLabel,
            textField,
            timerLabel,
            resultLabel,
            checkImageView,
            nextButton,
            resetButton
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
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalTo(textField.snp.trailing).inset(17)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalTo(resultLabel)
            $0.leading.equalTo(resultLabel.snp.trailing).offset(4)
            $0.width.equalTo(16)
            $0.height.equalTo(11)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(9)
            $0.height.equalTo(49)
        }
        
        resetButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textField.snp.bottom).offset(40)
        }
    }
}

// MARK: - binding
extension InputVerificationCodeViewController {
    private func bindView() {
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (self, _) in
                self.viewModel.resetTimer()
                self.startTimer()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .subscribe { (self, _) in
                let coordinator = ResetPasswordCoordinator(navigationController: self.navigationController)
                coordinator.start()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = InputVerificationCodeViewModel.Input(
            inputVerificationCode: textField.rx.text.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.isCorrectCode
            .withUnretained(self)
            .subscribe { (self, state) in
                self.updateUI(verificationState: state)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Textfeild delegate
extension InputVerificationCodeViewController: UITextFieldDelegate {    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension InputVerificationCodeViewController {
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

fileprivate extension Int {
    var toFormattedTime: String {
        let minutes = self / 60
        let remainingSeconds = self % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
