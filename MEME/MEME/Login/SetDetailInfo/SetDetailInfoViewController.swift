//
//  SetDetailInfoViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit

final class SetDetailInfoViewController: UIViewController {

    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var womanView: DetailSettingView!
    @IBOutlet private weak var manView: DetailSettingView!
    @IBOutlet private weak var drySkinView: DetailSettingView!
    @IBOutlet private weak var neutralSkinView: DetailSettingView!
    @IBOutlet private weak var oilySkinView: DetailSettingView!
    @IBOutlet private weak var combinationSkinView: DetailSettingView!
    @IBOutlet private weak var unknownSkinView: DetailSettingView!
    @IBOutlet private weak var springColorView: DetailSettingView!
    @IBOutlet private weak var summerColorView: DetailSettingView!
    @IBOutlet private weak var fallColorView: DetailSettingView!
    @IBOutlet private weak var winterColorView: DetailSettingView!
    @IBOutlet private weak var unknownColorView: DetailSettingView!
    
    private lazy var genderViews = [womanView, manView]
    private lazy var skinViews = [
        drySkinView,
        neutralSkinView,
        oilySkinView,
        combinationSkinView,
        unknownSkinView
    ]
    private lazy var colorViews = [
        springColorView,
        summerColorView,
        fallColorView,
        winterColorView,
        unknownColorView
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "회원가입")
        progressBar.configure(progress: 2)
        completeButton.layer.cornerRadius = 10
        setDetailSettingView()
    }
    
    private func setDetailSettingView() {
        womanView.configure(title: "여자", tag: 0, type: .gender)
        manView.configure(title: "남자", tag: 1, type: .gender)
        drySkinView.configure(title: "건성", tag: 2, type: .skinType)
        neutralSkinView.configure(title: "중성", tag: 3, type: .skinType)
        oilySkinView.configure(title: "지성", tag: 4, type: .skinType)
        combinationSkinView.configure(title: "복합성", tag: 5, type: .skinType)
        unknownSkinView.configure(title: "모르겠음", tag: 6, type: .skinType)
        springColorView.configure(title: "봄", tag: 7, type: .personalColor)
        summerColorView.configure(title: "여름", tag: 8, type: .personalColor)
        fallColorView.configure(title: "가을", tag: 9, type: .personalColor)
        winterColorView.configure(title: "겨울", tag: 10, type: .personalColor)
        unknownColorView.configure(title: "모르겠음", tag: 11, type: .personalColor)
        
        genderViews.forEach {
            $0?.delegate = self
        }
        
        skinViews.forEach {
            $0?.delegate = self
        }
        
        colorViews.forEach {
            $0?.delegate = self
        }
    }
    
    private func setNextButton() {
        
    }

}

extension SetDetailInfoViewController: DetailSettingButtonTapped {
    private func setGenderView(tag: Int) {
        genderViews.forEach {
            $0?.deselect(tag: tag)
        }
    }
    
    private func setSkinView(tag: Int) {
        skinViews.forEach {
            $0?.deselect(tag: tag)
        }
    }
    
    private func setColorView(tag: Int) {
        colorViews.forEach {
            $0?.deselect(tag: tag)
        }
    }
    
    func detailSettingButtonTapped(
        isSelected: Bool,
        tag: Int,
        type: DetailSettingViewType
    ) {
        if isSelected {
            switch type {
            case .gender:
                setGenderView(tag: tag)
            case .skinType:
                setSkinView(tag: tag)
            case .personalColor:
                setColorView(tag: tag)
            }
        }
        
        setNextButton()
    }
}

extension SetDetailInfoViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
