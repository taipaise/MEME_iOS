//
//  SortOptionsViewController.swift
//  MEME
//
//  Created by 정민지 on 1/21/24.
//

import UIKit
import SnapKit

class SortOptionsViewController: UIViewController {
    // MARK: - Properties
    private let reviewOrderButton = createButton(title: "리뷰순")
    private let lowerPriceButton = createButton(title: "가격 낮은 순")
    private let higherPriceButton = createButton(title: "가격 높은 순")
    var onOptionSelected: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        makeConstraints()
    }

    // MARK: - Setup Views
    private func configureSubviews() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        view.addSubview(reviewOrderButton)
        view.addSubview(lowerPriceButton)
        view.addSubview(higherPriceButton)

        reviewOrderButton.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
        lowerPriceButton.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
        higherPriceButton.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
    }

    // MARK: - Constraints
    private func makeConstraints() {
        reviewOrderButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        lowerPriceButton.snp.makeConstraints { make in
            make.top.equalTo(reviewOrderButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        higherPriceButton.snp.makeConstraints { make in
            make.top.equalTo(lowerPriceButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }

    // MARK: - Actions
    // 여기 이제 정렬 순서에 따라 API 호출하는 걸로 수정 필요
    @objc private func optionSelected(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        onOptionSelected?(title)
        dismiss(animated: true)
    }

    // MARK: - Helper Methods
    private static func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .white
        button.layer.borderWidth = 0
        
        return button
    }
}
