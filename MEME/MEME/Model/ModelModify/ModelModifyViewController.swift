//
//  ModelModifyViewController.swift
//  MEME
//
//  Created by 임아영 on 1/21/24.
//


import UIKit
import PhotosUI

final class ModelModifyViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    var selectedGenderTag: Int?
    var selectedSkinTypeTag: Int?
    var selectedPersonalColorTag: Int?
    
    var request: ModelProfileRequest?
    var response: ModelProfileResponse?
    var getresponse: ModelProfileInfoResponse?


    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var womanView: ModelDetailSettingView!
    @IBOutlet private weak var manView: ModelDetailSettingView!
    @IBOutlet private weak var drySkinView: ModelDetailSettingView!
    @IBOutlet private weak var neutralSkinView: ModelDetailSettingView!
    @IBOutlet private weak var oilySkinView: ModelDetailSettingView!
    @IBOutlet private weak var combinationSkinView: ModelDetailSettingView!
    @IBOutlet private weak var unknownSkinView: ModelDetailSettingView!
    @IBOutlet private weak var springColorView: ModelDetailSettingView!
    @IBOutlet private weak var summerColorView: ModelDetailSettingView!
    @IBOutlet private weak var fallColorView: ModelDetailSettingView!
    @IBOutlet private weak var winterColorView: ModelDetailSettingView!
    @IBOutlet private weak var unknownColorView: ModelDetailSettingView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var modifyImageView: UIImageView!
    
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
        
        ModelProfileInfoManager.shared.getModelProfileInfo(userId: 6) { [weak self] result in
            switch result {
            case .success(let response):
                print("Success: \(response)")
                self?.getresponse = response
                if let data = response.data {
                    DispatchQueue.main.async {
                        self?.nameTextField.text = data.nickname
                        
                        self?.genderViews.forEach { view in
                            if view?.label.text == data.gender.displayText {
                                view?.setSelected()
                            }
                        }
                        self?.skinViews.forEach { view in
                            if view?.label.text == data.skinType.displayText {
                                view?.setSelected()
                            }
                        }
                        self?.colorViews.forEach { view in
                            if view?.label.text == data.personalColor.displayText {
                                view?.setSelected()
                            }
                        }
                        self?.setUI()
                    }
                } else {
                    print("data nil")
                }

            case .failure(let error):
                print("Failure: \(error)")
            }
        }

        
        navigationItem.title = "프로필 관리"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)]
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.icBack, for: .normal)
        backButton.configuration?.imagePadding = 25
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.tabBarController?.tabBar.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            modifyImageView.isUserInteractionEnabled = true
            modifyImageView.addGestureRecognizer(tapGesture)
        

        setUI()
    }
    
    @objc func imageTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "사진 촬영", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                print("Camera not available")
                return
            }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setUI() {
        completeButton.layer.cornerRadius = 10
        modifyImageView.layer.cornerRadius = 14
        
        nameTextField.borderStyle = .none
        nameTextField.layer.cornerRadius = 9
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray200.cgColor
//        nameTextField.text = "차차"
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: nameTextField.frame.height))
        nameTextField.leftView = leftPaddingView
        nameTextField.leftViewMode = .always

        configureDetailSettingViews()
        
        profileImageView.image = .profile
        modifyImageView.image = .pencil
    }
    
    private func configureDetailSettingViews() {
        
        womanView.configure(title: "여성", tag: 0, type: .gender)
        manView.configure(title: "남성", tag: 1, type: .gender)
        drySkinView.configure(title: "건성", tag: 2, type: .skinType)
        neutralSkinView.configure(title: "중성", tag: 3, type: .skinType)
        oilySkinView.configure(title: "지성", tag: 4, type: .skinType)
        combinationSkinView.configure(title: "복합성", tag: 5, type: .skinType)
        unknownSkinView.configure(title: "모르겠음", tag: 6, type: .skinType)
        springColorView.configure(title: "봄웜톤", tag: 7, type: .personalColor)
        springColorView.setSelected()
        summerColorView.configure(title: "여름쿨톤", tag: 8, type: .personalColor)
        fallColorView.configure(title: "가을웜톤", tag: 9, type: .personalColor)
        winterColorView.configure(title: "겨울쿨톤", tag: 10, type: .personalColor)
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
    
//    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
//        // 이미지 업로드 로직
//        
//        // 이미지 업로드
//        uploadImage(selectedImage) { [weak self] imageUrl in
//            guard let imageUrl = imageUrl else {
//                print("Image upload failed")
//                return
//            }
//        }
//            // 이미지 URL 저장
//            self?.uploadedImageUrl = imageUrl
//            
//            // 프로필 업데이트
//            self?.completeButtonTapped(self?.completeButton ?? UIButton())
//        }

    @IBAction func completeButtonTapped(_ sender: Any) {
        let profileImg = /*uploadedImageUrl ??*/ ""
        let nickname = nameTextField.text ?? ""
        
        let selectedGender = genderViews.first(where: { $0?.tag == selectedGenderTag })??.button.titleLabel?.text
        let gender = Gender.rawValueFrom(displayText: selectedGender ?? "")

        let selectedSkinTypeText = skinViews.first(where: { $0?.tag == selectedSkinTypeTag })??.button.titleLabel?.text
          let skinType = SkinType.rawValueFrom(displayText: selectedSkinTypeText ?? "")

          let selectedPersonalColorText = colorViews.first(where: { $0?.tag == selectedPersonalColorTag })??.button.titleLabel?.text
          let personalColor = PersonalColor.rawValueFrom(displayText: selectedPersonalColorText ?? "")

          ModelProfileManager.shared.patchProfile(userId: 6, profileImg: profileImg, nickname: nickname, gender: gender, skinType: skinType, personalColor: personalColor) { result in
              switch result {
              case .success(let response):
                  print("Profile updated successfully: \(response)")
              case .failure(let error):
                  print("Failed to update profile: \(error)")
              }
          }
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }
        results[0].itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ModelModifyViewController: DetailSetButtonTapped {
   
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
    
    func detailSetButtonTapped(
        isSelected: Bool,
        tag: Int,
        type: DetailSetViewType
    ) {
        var views: [ModelDetailSettingView?]
        switch type {
        case .gender:
            views = genderViews
        case .skinType:
            views = skinViews
        case .personalColor:
            views = colorViews
        }
        views.forEach { $0?.deselect(tag: tag) }
        
        if isSelected {
               switch type {
               case .gender:
                   selectedGenderTag = tag
               case .skinType:
                   selectedSkinTypeTag = tag
               case .personalColor:
                   selectedPersonalColorTag = tag
               }
        }
    }

}
