//
//  TermDetailViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class TermDetailViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UITextView!
    private var state: TermsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let state = state {
            configureTerm(title: state.title, content: state.data)
        }
    }
    
    
    func configure(state: TermsData) {
        self.state = state
    }
    
    private func configureTerm(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
