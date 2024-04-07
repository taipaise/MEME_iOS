//
//  SetDetailInfoViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import AuthenticationServices

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
    private let userDefaultManager = UserDefaultManager.shared
    
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
    
    private var selectedSkinType: String?
    private var selectedPersonalColor: String?
    private var selectedGender: String?
    private var profileInfoBuilder: ProfileInfoBuilder?
    
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
        setNextButton()
    }
    
    func configure(builder: ProfileInfoBuilder) {
        profileInfoBuilder = builder
    }
    
    private func setDetailSettingView() {
        womanView.configure(title: Gender.FEMALE.korString, tag: 0, type: .gender)
        manView.configure(title: Gender.MALE.korString, tag: 1, type: .gender)
        drySkinView.configure(title: SkinType.DRY.korString, tag: 2, type: .skinType)
        neutralSkinView.configure(title: SkinType.COMMON.korString, tag: 3, type: .skinType)
        oilySkinView.configure(title: SkinType.OILY.korString, tag: 4, type: .skinType)
        combinationSkinView.configure(title: SkinType.COMBINATIONAL.korString, tag: 5, type: .skinType)
        unknownSkinView.configure(title: SkinType.UNKNOWN.korString, tag: 6, type: .skinType)
        springColorView.configure(title: PersonalColor.SPRING.korString, tag: 7, type: .personalColor)
        summerColorView.configure(title: PersonalColor.SUMMER.korString, tag: 8, type: .personalColor)
        fallColorView.configure(title: PersonalColor.AUTUMN.korString, tag: 9, type: .personalColor)
        winterColorView.configure(title: PersonalColor.WINTER.korString, tag: 10, type: .personalColor)
        unknownColorView.configure(title: PersonalColor.UNKNOWN.korString, tag: 11, type: .personalColor)
        
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
        guard
            selectedGender != nil,
            selectedSkinType  != nil,
            selectedPersonalColor != nil
        else {
            completeButton.backgroundColor = .gray300
            completeButton.isEnabled = false
            return
        }
        completeButton.isEnabled = true
        completeButton.backgroundColor = .mainBold
    }
    
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        guard
            let skinType = selectedSkinType,
            let color = selectedPersonalColor,
            let gender = selectedGender,
            let socialProvider = userDefaultManager.getProvider(),
            var builder = profileInfoBuilder,
            var token = userDefaultManager.getIdToken()
        else { return }
            
        builder = builder.idToken(token)
        builder = builder.skinType(skinType)
        builder = builder.personalColor(color)
        builder = builder.gender(gender)
        builder = builder.provider(socialProvider)
        
        AuthManager.shared.modelSignUp(profileInfo: builder.build()) { [weak self] result in
            switch result {
            case .success(let data):
                KeyChainManager.save(forKey: .memberId, value: String(data.data.userId))
                KeyChainManager.save(forKey: .accessToken, value: data.data.accessToken)
                KeyChainManager.save(forKey: .refreshToken, value: data.data.refreshToken)
                KeyChainManager.save(forKey: .role, value: "MODEL")
                let nextVC = RegistrationCompletionViewController()
                nextVC.configure(isArtist: false)
                self?.navigationController?.pushViewController(nextVC, animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SetDetailInfoViewController: DetailSettingButtonTapped {
    func detailSettingButtonTapped(title: String, type: DetailSettingViewType) {
        switch type {
        case .gender:
            setGenderView(title: title)
        case .personalColor:
            setColorView(title: title)
        case .skinType:
            setSkinView(title: title)
        }
        
        setNextButton()
    }
    
    private func setGenderView(title: String) {
        Gender.allCases.forEach { gender in
            if title == gender.korString {
                selectedGender = gender.rawValue
            }
        }
        
        genderViews.forEach {
            $0?.deselect(title: title)
        }
    }
    
    private func setSkinView(title: String) {
        SkinType.allCases.forEach { type in
            if title == type.korString {
                selectedSkinType = type.rawValue
            }
        }
        
        skinViews.forEach {
            $0?.deselect(title: title)
        }
    }
    
    private func setColorView(title: String) {
        PersonalColor.allCases.forEach { color in
            if title == color.korString {
                selectedPersonalColor = color.rawValue
            }
        }
        
        colorViews.forEach {
            $0?.deselect(title: title)
        }
    }
}

extension SetDetailInfoViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
