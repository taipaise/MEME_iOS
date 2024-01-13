//
//  RoleSelectionViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class RoleSelectionViewController: UIViewController {

    
    @IBOutlet weak var navigationBar: NavigationBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        navigationBar.delegate = self
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
    }
}

extension RoleSelectionViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
