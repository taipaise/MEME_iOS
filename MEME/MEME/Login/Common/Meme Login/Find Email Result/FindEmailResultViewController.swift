//
//  FindEmailResultViewController.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FindEmailResultViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일을 찾았어요!"
        label.font = .pretendard(to: .semiBold, size: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 바로 로그인 해보세요"
        label.font = .pretendard(to: .regular, size: 14)
        label.textColor = .gray500
        return label
    }()
    
    private lazy var emailContentView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray400.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인하러 가기"
        label.font = .pretendard(to: .semiBold, size: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .medium, size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var nextImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .icRightArrow
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let viewModel: FindEmailResultViewModel
    private var disposeBag = DisposeBag()
    
    init(email: String) {
        viewModel = .init(email: email)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        setUI()
        bindView()
        bindViewModel()
    }
    
    private func setUI() {
        view.backgroundColor = .white
    }
}

// MARK: - layout configuration
extension FindEmailResultViewController {
    private func addSubviews() {
        view.addSubViews([
            titleLabel,
            descriptionLabel,
            emailContentView,
            loginButton
        ])
        
        emailContentView.addSubViews([
            loginLabel,
            emailLabel,
            nextImageView
        ])
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            $0.leading.equalToSuperview().offset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
        }
        
        emailContentView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(92)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(emailContentView)
            $0.leading.equalTo(emailContentView)
            $0.size.equalTo(emailContentView)
        }
        
        loginLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().offset(24)
        }
        
        emailLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-22)
            $0.leading.equalToSuperview().offset(24)
        }
        
        nextImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(5.96)
            $0.height.equalTo(11.93)
        }
    }
}

// MARK: - Binding
extension FindEmailResultViewController {
    private func bindView() {
        loginButton.rx.tap
            .withUnretained(self)
            .subscribe { (self, _) in
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
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(.init())
        output.email
            .withUnretained(self)
            .subscribe { (self, email) in
                self.emailLabel.text = email
            }
            .disposed(by: disposeBag)
    }
}
