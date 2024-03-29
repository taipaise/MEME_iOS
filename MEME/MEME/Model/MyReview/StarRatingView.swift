//
//  StarRatingView.swift
//  MEME
//
//  Created by 임아영 on 1/29/24.
//

import UIKit

class StarRatingView: UIStackView {
    var starsRating = 0
    var starButtons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.spacing = 7  // 버튼 사이의 간격을 5로 설정
        setupStarButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.spacing = 7  // 버튼 사이의 간격을 5로 설정
        setupStarButtons()
    }
    
    private func setupStarButtons() {
        for button in starButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        starButtons.removeAll()
        
        for _ in 1...5 {
            let button = UIButton()
            
            button.setImage(UIImage.star, for: .selected) 
            button.setImage(UIImage.star2, for: .normal)
            
            addArrangedSubview(button)
            starButtons.append(button)
            
            button.addTarget(self, action: #selector(starButtonTapped(button:)), for: .touchUpInside)
        }
    }
    
    @objc func starButtonTapped(button: UIButton) {
        guard let index = starButtons.firstIndex(of: button) else {
            return
        }
        
        let selectedRating = index + 1
        
        if selectedRating == starsRating {
            starsRating = 0
        } else {
            starsRating = selectedRating
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in starButtons.enumerated() {
            button.isSelected = index < starsRating
        }
    }
    func setStarsRating(rating: Int) {
        starsRating = rating
        updateButtonSelectionStates()
    }
}
