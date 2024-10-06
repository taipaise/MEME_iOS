//
//  FindAccountViewController.swift
//  MEME
//
//  Created by 이동현 on 7/13/24.
//

import UIKit

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
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 12)
        label.textColor = .mainBold
        label.text = "3:00"
        return label
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .regular, size: 12)
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.backgroundColor = .mainBold
        button.layer.cornerRadius = 10
        return button
    }()
    
    init(mode: FindAccountMode, code: String?) {
        super.init(nibName: nil, bundle: nil)
        updateUI(mode)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addSubviews()
        makeConstraints()
    }
    
    private func setUI() {
        view.backgroundColor = .white
    }
}

// MARK: - layout configuration
extension InputEmailViewController {
    private func addSubviews() {
        view.addSubViews([
            descriptionLabel,
            textField,
            resultLabel,
            checkImageView,
            timerLabel,
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
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalTo(textField.snp.trailing).inset(17)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
        }
        
        checkImageView.snp.makeConstraints {
            $0.leading.equalTo(resultLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(resultLabel)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(9)
            $0.height.equalTo(49)
        }
    }
}

// MARK: - UI
extension InputEmailViewController {
    private func updateUI(_ mode: FindAccountMode) {
        descriptionLabel.text = mode.description
        textField.placeholder = mode.placeholder
        switch mode {
        case .findEmail:
            resultLabel.text = "가입되지 않은 닉네임입니다."
            resultLabel.textColor = .red
            resultLabel.isHidden = true
            checkImageView.isHidden = true
            timerLabel.isHidden = true
        case .findPassword:
            resultLabel.text = "가입되지 않은 이메일입니다."
            resultLabel.textColor = .red
            resultLabel.isHidden = true
            checkImageView.isHidden = true
            timerLabel.isHidden = true
        case .verifyCode:
            resultLabel.text = "인증코드 일치"
            resultLabel.textColor = .gray400
            resultLabel.isHidden = false
            checkImageView.image = .checkGray
            checkImageView.isHidden = false
            timerLabel.isHidden = false
        }
    }
}
