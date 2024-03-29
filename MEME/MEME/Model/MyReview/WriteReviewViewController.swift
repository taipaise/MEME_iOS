//
//  WriteReview.swift
//  MEME
//
//  Created by 임아영 on 1/29/24.
//

import UIKit
import PhotosUI

class WriteReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate, UITextViewDelegate  {
    
    var data = [AvailableReviewResponseData]()

    var starRatingView: StarRatingView!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let starLabel = UILabel()
    
    let lineView = UIView()
    
    let makeUpRvLabel = UILabel()
    
    let imageView = UIImageView()
    
    let image = UIImage.delete
    
    lazy var deleteButton: UIButton = {
        let deletebtn = UIButton(type: .custom)
        deletebtn.setImage(image, for: .normal)
        deletebtn.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        
        return deletebtn
    }()
    
    let warningLabel = UILabel()
    
    let upLoadButton: UIButton = {
        let btn = UIButton(type: .system)
//        btn.addTarget(WriteReviewViewController.self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    
    let reviewTextView = UITextView()
    
    let laterButton: UIButton = {
        let laterbtn = UIButton(type: .system)
        laterbtn.addTarget(WriteReviewViewController.self, action: #selector(laterButtonTapped), for: .touchUpInside)
        
        return laterbtn
    }()
    
    
    let setButton: UIButton = {
        let setbtn = UIButton(type: .system)
        setbtn.addTarget(WriteReviewViewController.self, action: #selector(setButtonTapped), for: .touchUpInside)
        
        return setbtn
    }()
    
    func updateReviewLabel(artistName: String, makeupName: String) {
        print("updateReviewLabel 호출됨")
        let labelText = "\(artistName)의\n\(makeupName)은 어땠나요?"
        let attributedString = NSMutableAttributedString(string: labelText)
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont(name: "Pretendard-SemiBold", size: 20)!]

        let artistNameRange = (labelText as NSString).range(of: artistName)
        let makeupNameRange = (labelText as NSString).range(of: makeupName)

        attributedString.addAttributes(boldFontAttribute, range: artistNameRange)
        attributedString.addAttributes(boldFontAttribute, range: makeupNameRange)

        reviewLabel.attributedText = attributedString
    }

    var imageViewHeightConstraint: NSLayoutConstraint?
    var reviewTextViewTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let laterButton = UIButton(type: .system)
            laterButton.addTarget(self, action: #selector(laterButtonTapped), for: .touchUpInside)
            self.view.addSubview(laterButton)
            
            let setButton = UIButton(type: .system)
            setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
            self.view.addSubview(setButton)
            
        
        self.tabBarController?.tabBar.isHidden = true
        
        starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starRatingView)
        
        reviewTextView.delegate = self
        reviewTextView.text = "여기에 리뷰를 작성해주세요."
        reviewTextView.textColor = UIColor.lightGray
        
        configureUI()
        loadReviewData()
    }
    func loadReviewData() {
        AvailableReviewManager.shared.getAvailableReview(modelId: 1, reservationId: 3, portfolioId: 3, artistNickName: "artistNickName", makeupName: "makeupName", reservationDate: "reservationDate", portfolioImg: "portfolioImg", shopLocation: "shopLocation") { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let firstReviewData = response.data?.first {
                        let artistNickName = firstReviewData.artistNickName
                        let makeupName = firstReviewData.makeupName ?? ""
                        self?.updateReviewLabel(artistName: artistNickName, makeupName: makeupName)
                    }
                    
                }

            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "Pretendard-Medium", size: 14)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "여기에 리뷰를 작성해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func configureUI() {
        navigationItem.title = "나의 리뷰"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.pretendard(to: .regular, size: 16)]
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.icBack, for: .normal)
        backButton.configuration?.imagePadding = 25
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        view.backgroundColor = .white
        
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        makeUpRvLabel.translatesAutoresizingMaskIntoConstraints = false
        upLoadButton.translatesAutoresizingMaskIntoConstraints = false
        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        laterButton.translatesAutoresizingMaskIntoConstraints = false
        setButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        
        contentView.addSubview(reviewLabel)
        NSLayoutConstraint.activate([
            reviewLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            reviewLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 87),
            
            starRatingView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 23),
            starRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 81),
            starRatingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -81),
            starRatingView.heightAnchor.constraint(equalToConstant: 37)
        ])
        
        contentView.addSubview(starLabel)
        starLabel.text = "별점을 선택해주세요"
        starLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        starLabel.textColor = UIColor.gray400
        NSLayoutConstraint.activate([
            starLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            starLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 14)
        ])
        
        contentView.addSubview(lineView)
        lineView.backgroundColor = UIColor.gray400
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: starLabel.bottomAnchor, constant: 15),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        contentView.addSubview(makeUpRvLabel)
        makeUpRvLabel.text = "메이크업 후기를 남겨주세요"
        makeUpRvLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        makeUpRvLabel.textColor = UIColor.black
        NSLayoutConstraint.activate([
            makeUpRvLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            makeUpRvLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 35)
        ])
        
        contentView.addSubview(upLoadButton)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(named: "camera")
        configuration.imagePadding = 10
        configuration.titlePadding = 10
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        let nsAttributedString = NSAttributedString(string: "사진 업로드", attributes: attributes)
        configuration.attributedTitle = AttributedString(nsAttributedString)
        
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = .mainBold
        configuration.background = background
        upLoadButton.layer.cornerRadius = 7
        upLoadButton.clipsToBounds = true
        upLoadButton.configuration = configuration
        upLoadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            upLoadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            upLoadButton.topAnchor.constraint(equalTo: makeUpRvLabel.bottomAnchor, constant: 8),
            upLoadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            upLoadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            upLoadButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        contentView.addSubview(imageView)
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: upLoadButton.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageViewHeightConstraint!
        ])
        
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 18),
            deleteButton.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        contentView.addSubview(warningLabel)
        warningLabel.text = "무관한 사진/동영상을 첨부한 리뷰는 통보없이 삭제될 수 있습니다."
        warningLabel.font = UIFont.pretendard(to: .regular, size: 12)
        warningLabel.textColor = .red
        warningLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            warningLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        contentView.addSubview(reviewTextView)
        reviewTextView.font = UIFont(name: "Pretendard-Medium", size: 14)
        reviewTextView.layer.cornerRadius = 9
        reviewTextView.delegate = self
        reviewTextView.layer.borderColor = UIColor.mainBold.cgColor
        reviewTextView.layer.borderWidth = 1
        
        contentView.addSubview(laterButton)
        contentView.addSubview(setButton)
        laterButton.setTitle("나중에 작성", for: .normal)
        setButton.setTitle("등록하기", for: .normal)
        laterButton.layer.cornerRadius = 10
        setButton.layer.cornerRadius = 10
        
        laterButton.backgroundColor = .gray400
        setButton.backgroundColor = .mainBold
        
        laterButton.setTitleColor(.white, for: .normal)
        setButton.setTitleColor(.white, for: .normal)

        reviewTextViewTopConstraint = reviewTextView.topAnchor.constraint(equalTo: upLoadButton.bottomAnchor, constant: 10)
        
        reviewTextViewTopConstraint = reviewTextView.topAnchor.constraint(equalTo: upLoadButton.bottomAnchor, constant: 10)
        NSLayoutConstraint.activate([
            reviewTextViewTopConstraint!,
            reviewTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            reviewTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            reviewTextView.heightAnchor.constraint(equalToConstant: 200),
            reviewTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            laterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            laterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            laterButton.heightAnchor.constraint(equalToConstant: 49),
            
            setButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            setButton.leadingAnchor.constraint(equalTo: laterButton.trailingAnchor, constant: 5),
            setButton.heightAnchor.constraint(equalToConstant: 49),
            setButton.widthAnchor.constraint(equalTo: laterButton.widthAnchor),
            setButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
        
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        contentViewHeightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            contentViewHeightConstraint,
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: reviewTextView.bottomAnchor, constant: 40)
        ])
    }
    
    @objc func uploadButtonTapped() {
        presentImagePicker()
    }
    
    func presentImagePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "사진 촬영", style: .default, handler: { _ in
            self.presentCamera()
        }))
        alert.addAction(UIAlertAction(title: "앨범에서 선택", style: .default, handler: { _ in
            self.presentPhotoPicker()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
        imageViewHeightConstraint?.constant = 100
        reviewTextViewTopConstraint?.isActive = false
        reviewTextViewTopConstraint = reviewTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        reviewTextViewTopConstraint?.isActive = true
        warningLabel.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async { [self] in
                        self.imageView.image = image
                        //                        self.imageViewTopConstraint?.constant += self.imageView.frame.height
                        //                        UIView.animate(withDuration: 0.3) {
                        //                            self.view.layoutIfNeeded()
                        self.imageViewHeightConstraint?.constant = 100  // 이미지 뷰의 높이를 업데이트
                        self.reviewTextViewTopConstraint?.isActive = false
                        reviewTextViewTopConstraint = reviewTextView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10)
                        reviewTextViewTopConstraint?.isActive = true
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    func loadImageFromUrl(imageUrl: String) {
        guard let url = URL(string: imageUrl) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(String(describing: error))")
                return
            }
            
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
        }.resume()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func laterButtonTapped() {
        print("나중에 작성 버튼이 눌렸습니다.")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setButtonTapped() {
        setTap()
    }
    func setTap() {
        PostReviewManager.shared.postReview(modelId: 1, reservationId: 3, star: 5, comment: "좋아요!", reviewImgSrc: ["image_url_1", "image_url_2"]) { result in
            switch result {
            case .success(let response):
                print("성공: 리뷰가 성공적으로 등록되었습니다.")
            case .failure(let error):
                print("요청 실패: \(error)")
            }
        }
    }
    @objc func deleteImage() {
        imageView.image = nil
        warningLabel.isHidden = true
        deleteButton.isHidden = true
        
        imageViewHeightConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
