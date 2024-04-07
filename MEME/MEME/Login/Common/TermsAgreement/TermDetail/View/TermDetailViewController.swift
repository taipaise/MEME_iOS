//
//  TermDetailViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TermDetailViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UITextView!
    @IBOutlet private weak var dismissButton: UIButton!
    private var viewMoldel: TermDetailViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func configure(termType: TermsData) {
        viewMoldel = TermDetailViewModel(termType: termType)
    }
}

// MARK: - Binding
extension TermDetailViewController {
    private func bind() {
        guard let viewMoldel = viewMoldel else { return }
        let output = viewMoldel.transform(TermDetailViewModel.Input())
        
        output.title.subscribe { [weak self] title in
            self?.titleLabel.text = title
        }
        .disposed(by: disposeBag)
        
        output.content.subscribe { [weak self] content in
            self?.contentLabel.text = content
        }
        .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
