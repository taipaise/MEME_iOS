//
//  SetDetailInfoViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class SetDetailInfoViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        navigationBar.delegate = self
    }

}

extension SetDetailInfoViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
