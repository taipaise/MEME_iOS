//
//  OnBoardingViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class OnBoardingViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    private func setUI() {
        startButton.setGradient(
            color1: .mainBold,
            color2: .mainLight,
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5),
            location: [0.5],
            cornerRadius: 10
        )
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        let nextVC = LoginViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
