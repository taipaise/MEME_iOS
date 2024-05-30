//
//  ArtistnfoViewController.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import UIKit
import PhotosUI

final class ArtistInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    weak var delegate: ArtistInfoUpdateDelegate?
    var artistProfileData: ArtistProfileData?
    
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
    
    private let careerPickerView: UIPickerView = {
            let pickerView = UIPickerView()
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            return pickerView
        }()
    private let careerData: [Int] = Array(0...10)

    private var phpPicker: PHPickerViewController?
    private var imagePicker: UIImagePickerController?
    
//    var request: ArtistProfileRequest?
    var response: ArtistProfileResponse?
    var getresponse: ArtistProfileInfoResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArtistProfileInfoManager.shared.getArtistProfileInfo(userId: KeyChainManager.loadMemberID()) { [weak self] result in
            switch result {
            case .success(let response):
                print("Success: \(response)")
                self?.getresponse = response
                if let data = response.data {
                    DispatchQueue.main.async {
                        self?.nameTextField.text = data.nickname
                        
                        if self?.femaleButton.titleLabel?.text == data.gender.korString {
                            self?.femaleButton.layer.borderColor = UIColor.mainBold.cgColor
                            self?.femaleButton.tintColor = .mainBold
                        } else {
                            self?.femaleButton.layer.borderColor = UIColor.gray300.cgColor
                            self?.femaleButton.tintColor = .black
                        }

                        if self?.maleButton.titleLabel?.text == data.gender.korString {
                            self?.maleButton.layer.borderColor = UIColor.mainBold.cgColor
                            self?.maleButton.tintColor = .mainBold
                        } else {
                            self?.maleButton.layer.borderColor = UIColor.gray300.cgColor
                            self?.maleButton.tintColor = .black
                        }
                        self?.introduceTextView.text = data.introduction

                        self?.careerLabel.text = data.workExperience.displayText

                        self?.setUI()

                    }
                } else {
                    print("data nil")
                }

            case .failure(let error):
                print("Failure: \(error)")
            }
        }
        
        self.tabBarController?.tabBar.isHidden = true

        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "프로필 입력")
        progressBar.configure(progress: 0)
        nextButton.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.image = .profile
        
        [
                nameTextField,
                introduceTextView,
                careerView
        ].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.gray400.cgColor
            $0?.layer.cornerRadius = 9
        }

        [femaleButton, maleButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.cornerRadius = 9
        }
        setUpPhpPicker()
        setUpimagePicker()
        scrollView.delegate = self
        
        careerPickerView.delegate = self
        careerPickerView.dataSource = self
        
        view.addSubview(careerPickerView)
        careerPickerView.backgroundColor = .white
        NSLayoutConstraint.activate([
            careerPickerView.topAnchor.constraint(equalTo: careerView.bottomAnchor),
            careerPickerView.leadingAnchor.constraint(equalTo: careerView.leadingAnchor),
            careerPickerView.trailingAnchor.constraint(equalTo: careerView.trailingAnchor)
        ])
        careerPickerView.isHidden = true
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
        careerPickerView.isHidden.toggle()
    }
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return careerData.count
    }

    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(careerData[row])년"
    }

    @objc func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        careerLabel.text = "\(careerData[row])년"
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
