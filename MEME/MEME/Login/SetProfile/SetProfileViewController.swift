//
//  SetProfileViewController.swift
//  MEME
//
//  Created by 이동현 on 1/13/24.
//

import UIKit
import PhotosUI

final class SetProfileViewController: UIViewController {
    
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var imageSelectButton: UIButton!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var noticeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    private var phpPicker: PHPickerViewController?
    private var imagePicker: UIImagePickerController?
    private var isArtist: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setUpPhpPicker()
        setUpimagePicker()
    }
   
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "회원가입")
        progressBar.configure(progress: 1)
        nextButton.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        imageSelectButton.layer.cornerRadius = imageSelectButton.frame.height / 2
    }
    
    func configure(isArtist: Bool) {
        self.isArtist = isArtist
    }
    
    @IBAction private func imageSelectButtonTapped(_ sender: Any) {
        guard
            let phpPicker = self.phpPicker,
            let imagePicker = self.imagePicker
        else { return }
        
        let alert = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        let albumAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { _ in
            self.present(phpPicker, animated: true)
        }
        let cameraAction = UIAlertAction(title: "사진 촬영", style: .default) { _ in
            self.present(imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(albumAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if isArtist {
            let nextVC = BusinessRegistrationViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = SetDetailInfoViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

// MARK: - 사진 선택 설정
extension SetProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true, completion: nil)
        guard
            let itemProvider = results.first?.itemProvider,
            itemProvider.canLoadObject(ofClass: UIImage.self)
        else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                guard let selectedImage = image as? UIImage else { return }
                self.profileImageView.image = selectedImage
            }
        }
    }
    
    private func setUpPhpPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        phpPicker = PHPickerViewController(configuration: configuration)
        phpPicker?.delegate = self
    }
}

extension SetProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        imagePicker?.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true)
    }
    
    private func setUpimagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.delegate = self
    }
}

// MARK: - 뒤로가기 delegate
extension SetProfileViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
