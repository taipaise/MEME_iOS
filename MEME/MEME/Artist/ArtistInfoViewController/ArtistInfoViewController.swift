//
//  ArtistnfoViewController.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import UIKit
import PhotosUI

final class ArtistInfoViewController: UIViewController {

    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var femaleButton: UIButton!
    @IBOutlet private weak var maleButton: UIButton!
    @IBOutlet private weak var introduceTextView: UITextView!
    @IBOutlet private weak var careerLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var careerView: UIView!
    
    private var phpPicker: PHPickerViewController?
    private var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "프로필 입력")
        progressBar.configure(progress: 0)
        nextButton.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        [
            nameTextField,
            femaleButton,
            maleButton,
            introduceTextView,
            careerView
        ].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.gray400.cgColor
            $0?.layer.cornerRadius = 9
        }
        
        setUpPhpPicker()
        setUpimagePicker()
        scrollView.delegate = self
    }
    
    
    @IBAction private func genderButtonTapped(_ sender: UIButton) {
        let buttons = [maleButton, femaleButton]
        
        buttons.forEach {
            if sender.tag == $0?.tag {
                $0?.layer.borderColor = UIColor.mainBold.cgColor
                $0?.tintColor = .mainBold
            } else {
                $0?.layer.borderColor = UIColor.gray300.cgColor
                $0?.tintColor = .black
            }
        }
    }
    
    @IBAction private func profileImageButtonTapped(_ sender: Any) {
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
    
    @IBAction private func careerButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        let nextVC = ArtistLocationViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - 사진 선택 설정
extension ArtistInfoViewController: PHPickerViewControllerDelegate {
    
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

extension ArtistInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
extension ArtistInfoViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ArtistInfoViewController: UIScrollViewDelegate {
    
}
