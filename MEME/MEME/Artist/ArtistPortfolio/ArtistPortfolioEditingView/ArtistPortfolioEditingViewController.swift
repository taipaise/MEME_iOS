//
//  ArtistPortfolioEditingViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/28/24.
//

import UIKit
import PhotosUI

class ArtistPortfolioEditingViewController: UIViewController {
    
    // MARK: - UI Properties
    @IBOutlet private weak var portfolioImageCollectionView: UICollectionView!
    @IBOutlet private weak var makeupCategoryCollectionView: UICollectionView!
    @IBOutlet private weak var makeupNameTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var infoTextView: UITextView!
    @IBOutlet private weak var infoTextViewPlaceHolderLabel: UILabel!
    
    private lazy var artistProfileEditingInfoBar: UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBold
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    let portfolioId: Int
    private var portfolioDetailData: PortfolioData!
    private var isBlock = false
    private var selectedCategory: PortfolioCategories?
    private var portfolioImage = [UIImage(), UIImage(), UIImage()]
    private var configuration = PHPickerConfiguration()
    private var imageCount = 0
    private var selectedImageIndexPath = 0
    
    // MARK: - Initialization
    init(receivedData: Int) {
        self.portfolioId = receivedData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if portfolioId == -1 {
            getPortfolioDetail()
        }
        configureSubviews()
        makeConstraints()
        collectionViewConfigure()
        setUI()
        setupDismissKeyboardOnTapGesture()
        imagePickerConfigure()
    }
    
    // MARK: - UI Setup
    private func setUI() {
        makeupCategoryCollectionView.backgroundColor = .white
        infoTextView.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        infoTextView.delegate = self
        infoTextView.layer.cornerRadius = 10
        infoTextView.layer.borderWidth = 1
        infoTextView.layer.borderColor = UIColor.gray200.cgColor
        
        priceTextField.keyboardType = .numberPad
        
        if portfolioId != -1 {
            artistProfileEditingInfoBar.setTitle("수정하기", for: .normal)
            self.navigationItem.title = "포트폴리오 수정"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: .icTrash.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(trashButtonDidTap))
        } else {
            self.navigationItem.title = "포트폴리오 추가"
            artistProfileEditingInfoBar.setTitle("추가하기", for: .normal)
        }
    }
    
    // MARK: - CollectionView Configuration
    private func collectionViewConfigure() {
        makeupCategoryCollectionView.delegate = self
        makeupCategoryCollectionView.dataSource = self
        makeupCategoryCollectionView.register(UINib(nibName: ArtistMakeupTagCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ArtistMakeupTagCollectionViewCell.className)
        
        portfolioImageCollectionView.delegate = self
        portfolioImageCollectionView.dataSource = self
        portfolioImageCollectionView.register(PortfolioImageCollectionViewCell.self, forCellWithReuseIdentifier: PortfolioImageCollectionViewCell.className)
    }
    
    // MARK: - UI Configuration
    private func configureSubviews() {
        view.addSubview(artistProfileEditingInfoBar)
    }
    
    private func makeConstraints() {
        artistProfileEditingInfoBar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(49)
        }
    }
    
    private func imagePickerConfigure() {
        configuration.selectionLimit = 1
        configuration.filter = .images
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        let title = portfolioId == -1 ? "포트폴리오 수정하기" : "포트폴리오 등록하기"
        let message = portfolioId == -1 ? "\n포트폴리오 수정을 취소하시겠습니까?" : "\n포트폴리오 등록을 취소하시겠습니까?"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
    }
    
    @objc func editButtonDidTap(_ sender: UIButton) {
        let title = portfolioId == -1 ? "포트폴리오 수정하기" : "포트폴리오 등록하기"
        let message = portfolioId == -1 ? "\n포트폴리오를 수정하시겠습니까?" : "\n포트폴리오를 등록하시겠습니까?"
        
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            // TODO: 포트폴리오 수정/등록
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func trashButtonDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "포트폴리오 삭제하기", message: "\n포트폴리오를 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.isBlock = true
            // TODO: 포트폴리오 삭제
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ArtistPortfolioEditingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == makeupCategoryCollectionView {
            return portfolioCategories.count
        } else {
            return imageCount == 3 ? 3 : imageCount + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == makeupCategoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistMakeupTagCollectionViewCell.className, for: indexPath) as? ArtistMakeupTagCollectionViewCell else { return UICollectionViewCell() }
            let tagName = portfolioCategories[indexPath.row].korName
            cell.makeupTagLabel.text = tagName
            
            if let selectedCategory = selectedCategory, selectedCategory == portfolioCategories[indexPath.row] {
                cell.selected()
            } else {
                cell.deSelected()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioImageCollectionViewCell.className, for: indexPath) as? PortfolioImageCollectionViewCell else { return UICollectionViewCell() }
            cell.hideDeleteButton(imageCount != 3 && indexPath.row == 0)
            cell.configure(image: imageCount == 3 ? portfolioImage[imageCount - 1 - indexPath.row] : (indexPath.row != 0 ? portfolioImage[imageCount - indexPath.row] : UIImage(named: "portfolio_image") ?? UIImage()))
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ArtistPortfolioEditingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == makeupCategoryCollectionView {
            if let selectedCell = collectionView.cellForItem(at: indexPath) as? ArtistMakeupTagCollectionViewCell {
                selectedCell.selected()
                selectedCategory = portfolioCategories[indexPath.row]
            }
            
            for visibleIndexPath in collectionView.indexPathsForVisibleItems {
                if visibleIndexPath != indexPath, let deselectedCell = collectionView.cellForItem(at: visibleIndexPath) as? ArtistMakeupTagCollectionViewCell {
                    deselectedCell.deSelected()
                }
            }
        } else {
            selectedImageIndexPath = indexPath.row
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
            portfolioImageCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ArtistPortfolioEditingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == makeupCategoryCollectionView {
            var width = 97
            switch indexPath.row {
            case 3:
                width += 23
            case 6:
                width += 8
            case 7:
                width += 38
            default:
                break
            }
            return CGSize(width: width, height: 27)
        } else {
            return CGSize(width: 80, height: 82)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 7
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 15
    }
}

// MARK: - API Calls
extension ArtistPortfolioEditingViewController {
    private func getPortfolioDetail() {
        // TODO: 포트폴리오 세부조회 API
    }
    
    private func createPortfolio() {
        // TODO: 포트폴리오 추가 API
    }
    
    private func editPortfolio() {
        // TODO: 포트폴리오 수정 API
    }
}

// MARK: - Keyboard Handling
extension ArtistPortfolioEditingViewController {
    func setupDismissKeyboardOnTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension ArtistPortfolioEditingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        infoTextViewPlaceHolderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: - PortfolioImageCollectionViewCellDelegate
extension ArtistPortfolioEditingViewController: PortfolioImageCollectionViewCellDelegate {
    func deleteButtonTapped(_ cell: PortfolioImageCollectionViewCell) {
        guard let indexPath = portfolioImageCollectionView.indexPath(for: cell) else { return }
        portfolioImage[2 - indexPath.row] = UIImage()
        moveEmptyImagesToEnd()
        imageCount -= 1
        if imageCount == 2 {
            let temp = portfolioImage[0]
            portfolioImage[0] = portfolioImage[1]
            portfolioImage[1] = temp
        }
        portfolioImageCollectionView.reloadData()
    }
    
    private func moveEmptyImagesToEnd() {
        portfolioImage.sort { (first, second) -> Bool in
            if first == UIImage() && second == UIImage() { return false }
            if first == UIImage() { return false }
            if second == UIImage() { return true }
            return true
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ArtistPortfolioEditingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let selectedImage = image as? UIImage else { return }
                    if self.imageCount == 3 {
                        self.portfolioImage[2 - self.selectedImageIndexPath] = selectedImage
                    } else {
                        self.portfolioImage[self.imageCount - self.selectedImageIndexPath] = selectedImage
                        if self.selectedImageIndexPath == 0 {
                            self.imageCount += 1
                        }
                    }
                    self.portfolioImageCollectionView.reloadData()
                }
            }
        }
    }
}
