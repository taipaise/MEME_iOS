//
//  ArtistPortfolioEditingViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/28/24.
//

import UIKit

class ArtistPortfolioEditingViewController: UIViewController, UINavigationControllerDelegate {
    //MARK: - UI Properties
    @IBOutlet private weak var makeupCategoryCollectionView: UICollectionView!
    @IBOutlet private weak var imagePickerStackView: UIStackView!
    
    @IBOutlet private weak var firstImgView: UIImageView!
    @IBOutlet private weak var secondImgView: UIImageView!
    @IBOutlet private weak var thirdImgView: UIImageView!
    
    @IBOutlet private weak var firstDeleteButton: UIButton!
    @IBOutlet private weak var secondDeleteButton: UIButton!
    @IBOutlet private weak var thirdDeleteButton: UIButton!
    
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
    
    //MARK: - init
    init(receivedData: Int) {
        self.portfolioId = receivedData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    let portfolioId: Int
    private var portfolioDetailData: PortfolioData!
    private var isBlock : Bool = false
    private var selectedCategory: PortfolioCategories?
    
    private var buttonAt: Int = 0
    private var imgCnt: Int = 0
    private var isEdit: Bool = portfolioIdx == -1 ? false : true
    private lazy var imgViewUrlList: [String] = []
    private var portfolioImageData: [ImageData]?
    private lazy var imgViewList: [UIImageView] = {
        return [self.firstImgView, self.secondImgView, self.thirdImgView]
    }()
    
    //MARK: - ViewController 생명 주기
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit {
            getPortfolioDetail()
        }
        configureSubviews()
        makeConstraints()
        collectionViewConfigure()
        setUI()
        setupDismissKeyboardOnTapGesture()
    }
    
    //MARK: - setUI()
    private func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        infoTextView.delegate = self
        infoTextView.layer.cornerRadius = 10
        infoTextView.layer.borderWidth = 1
        infoTextView.layer.borderColor = UIColor.gray200.cgColor
        priceTextField.keyboardType = .numberPad
        if !isEdit {
            artistProfileEditingInfoBar.setTitle("수정하기", for: .normal)
            self.navigationItem.title = "포트폴리오 수정"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: .icTrash.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(trashButtonDidTap))
        }else {
            self.navigationItem.title =  "포트폴리오 추가"
            artistProfileEditingInfoBar.setTitle("추가하기", for: .normal)
        }
        deleteButtonAppear()
    }
    
    //MARK: - collectionViewConfigure()
    private func collectionViewConfigure(){
        makeupCategoryCollectionView.delegate = self
        makeupCategoryCollectionView.dataSource = self
        makeupCategoryCollectionView.register(UINib(nibName: ArtistMakeupTagCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ArtistMakeupTagCollectionViewCell.className)
        
    }
    
    //MARK: - codebase UI config
    private func configureSubviews() {
        view.addSubview(artistProfileEditingInfoBar)
    }
    
    //MARK: - codebase UI constraints
    private func makeConstraints() {
        artistProfileEditingInfoBar.snp.makeConstraints {make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(49)
        }
    }
    
    //MARK: - deleteButtonAppear()
    private func deleteButtonAppear() {
        if self.imgCnt==3 {
            firstDeleteButton.isHidden = false
            secondDeleteButton.isHidden = false
            thirdDeleteButton.isHidden = false
        }else if self.imgCnt==2 {
            firstDeleteButton.isHidden = true
            secondDeleteButton.isHidden = false
            thirdDeleteButton.isHidden = false
        }else if self.imgCnt==1 {
            firstDeleteButton.isHidden = true
            secondDeleteButton.isHidden = false
            thirdDeleteButton.isHidden = true
        }else {
            firstDeleteButton.isHidden = true
            secondDeleteButton.isHidden = true
            thirdDeleteButton.isHidden = true
        }
    }
    //MARK: - @IBAction
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        var title = ""
        var message = ""
        
        if isEdit {
            title = "포트폴리오 수정하기"
            message = "\n포트폴리오 수정을 취소하시겠습니까?"
        } else {
            title = "포트폴리오 등록하기"
            message = "\n포트폴리오 등록을 취소하시겠습니까?"
        }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func editButtonDidTap(_ sender: UIButton) {
        let okCreateAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.createPortfolio(completion: { result in
                self?.navigationController?.popViewController(animated: true)
            })
        }
        let okEditAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.editPortfolio(completion: { result in
                self?.navigationController?.popViewController(animated: true)
            })
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        var title = ""
        var message = ""
        
        if isEdit {
            title = "포트폴리오 수정하기"
            message = "\n포트폴리오를 수정하시겠습니까?"
        } else {
            title = "포트폴리오 등록하기"
            message = "\n포트폴리오를 등록하시겠습니까?"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // HIG에 따라 Cancel이 왼쪽
        if isEdit{
            alert.addAction(okEditAction)
        }else {
            alert.addAction(okCreateAction)
        }
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    @IBAction func trashButtonDidTap(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "포트폴리오 삭제하기", message: "\n포트폴리오를 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.isBlock=true
            self?.editPortfolio(completion: { result in
                self?.navigationController?.popViewController(animated: true)
            })
        }
        let noAction = UIAlertAction(
            title: "아니오",
            style: .cancel,
            handler : nil
        )
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func pick(_ sender: UIButton) {
        // 이미지 피커 컨트롤러 생성
        buttonAt = sender.tag
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary // 이미지 소스로 사진 라이브러리 선택
        picker.allowsEditing = true // 이미지 편집 기능 On
        // 델리게이트 지정
        picker.delegate = self
        
        // 이미지 피커 컨트롤러 실행
        self.present(picker, animated: false)
    }
    @IBAction func deleteImg(_ sender: UIButton) {
        buttonAt = sender.tag
        if buttonAt==0 {
            imgViewList[0].image = .icPicture
        }else if buttonAt==1 {
            if imgCnt==1 {
                imgViewList[buttonAt].image = nil
                imgViewList[0].image = .icPicture
                imgViewUrlList[0] = "string"
            }else if imgCnt==2 {
                imgViewList[buttonAt].image = imgViewList[buttonAt+1].image
                imgViewList[buttonAt+1].image = nil
                imgViewList[0].image = .icPicture
            }else {
                imgViewList[buttonAt].image = imgViewList[buttonAt-1].image
                imgViewList[0].image = .icPicture
            }
        }else{
            if imgCnt==3 {
                imgViewList[buttonAt].image = imgViewList[buttonAt-1].image
                imgViewList[buttonAt-1].image = imgViewList[buttonAt-2].image
                imgViewList[0].image = .icPicture
            }else {
                imgViewList[buttonAt].image = nil
            }
        }
        imgCnt-=1
        deleteButtonAppear()
    }
    
}

//MARK: - UICollectionViewDataSource
extension ArtistPortfolioEditingViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portfolioCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistMakeupTagCollectionViewCell.className, for: indexPath) as? ArtistMakeupTagCollectionViewCell else { return UICollectionViewCell() }
        let tagName = portfolioCategories[indexPath.row].korName
        cell.makeupTagLabel.text = tagName
        
        if let selectedCategory = selectedCategory {
            if selectedCategory == portfolioCategories[indexPath.row] {
                cell.selected()
            } else {
            }
        } else {
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ArtistPortfolioEditingViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 indexPath에 대한 셀을 가져오기
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ArtistMakeupTagCollectionViewCell {
            // 선택된 셀에 대한 작업 수행
            selectedCell.selected()
            selectedCategory = portfolioCategories[indexPath.row]
        }
        
        // 나머지 indexPath에 대한 셀을 가져와서 작업 수행
        for visibleIndexPath in collectionView.indexPathsForVisibleItems {
            if visibleIndexPath != indexPath,
               let deselectedCell = collectionView.cellForItem(at: visibleIndexPath) as? ArtistMakeupTagCollectionViewCell {
                // 선택되지 않은 셀에 대한 작업 수행
                deselectedCell.deSelected()
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ArtistPortfolioEditingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
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
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CGFloat(7)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CGFloat(15)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ArtistPortfolioEditingViewController : UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // 이미지 피커 컨트롤러 창 닫기
            self.dismiss(animated: false) { () in
                // 알림 창 호출
                let alert = UIAlertController(
                    title: "",
                    message: "이미지 선택이 취소되었습니다.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "확인",
                    style: .cancel
                ))
                self.present(alert, animated: false)
            }
        }
        // 이미지 피커에서 이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 이미지 피커 컨트롤러 창 닫기
            picker.dismiss(animated: false) { () in
                let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                self.imgViewList[1].image = img
                self.imgCnt += 1
                self.deleteButtonAppear()

            }
        }
}

//MARK: - API 호출
extension ArtistPortfolioEditingViewController {
    private func getPortfolioDetail() {
        let getPortfolio = PortfolioManager.shared
        self.infoTextViewPlaceHolderLabel.isHidden = true
        getPortfolio.getPortfolioDetail(userId: modelID, portfolioId: portfolioId) { result in
            switch result {
            case .success(let response):
                if let url = URL(string: response.data!.portfolioImgDtoList![0].portfolioImgSrc) {
                    URLSession.shared.dataTask(
                        with: url) {
                            data, response, error in
                            DispatchQueue.main.async {
                                if let data = data, error == nil {
                                    self.imgCnt = 1
                                    self.deleteButtonAppear()
                                    self.secondImgView.image = UIImage(data: data)
                                } else {
                                    self.secondImgView.image = nil
                                }
                        }
                    }.resume()
                    self.portfolioImageData = response.data?.portfolioImgDtoList
                } else {
                    self.firstImgView.image = nil
                }
                self.portfolioDetailData = response.data
                self.selectedCategory = PortfolioCategories(rawValue: response.data!.category)
                self.makeupCategoryCollectionView.reloadData()
                self.makeupNameTextField.text = response.data?.makeupName
                self.priceTextField.text = String(response.data!.price)
                self.infoTextView.text = response.data?.info
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createPortfolio(completion: @escaping (Bool) -> Void) {
        let createPortfolio = PortfolioManager.shared
        createPortfolio.createPortfolio(
            artistId: artistID,
            category: selectedCategory!,
            makeup_name: makeupNameTextField.text!,
            price: Int(priceTextField.text!)!,
            info: infoTextView.text!,
            portfolio_img_src: imgViewUrlList
        ) { result in
            switch result {
            case .success(let data):
                print(data.message)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func editPortfolio(completion: @escaping (Bool) -> Void) {
        FirebaseStorageManager.uploadImage(image: imgViewList[0].image!) { [self] url in
            guard
                let url = url,
                let aritstId = KeyChainManager.read(forkey: .memberId) as? Int
            else { return } // 성공적으로 업로드 했으면 url이 nil 값이 아님
            portfolioImageData?[0].portfolioImgSrc = url.absoluteString
            portfolioImageData?[0].delete = false
            let editPortfolio = PortfolioManager.shared
            editPortfolio.editPortfolio(
                artistId: aritstId,
                portfolioId: portfolioId,
                category: selectedCategory!,
                makeup_name: makeupNameTextField.text!,
                price: Int(priceTextField.text!)!,
                info: infoTextView.text,
                isBlock: isBlock,
                portfolio_img_src: portfolioImageData!
            ) { result in
                switch result {
                case .success(let response):
                    print("성공" + response.message)
                    completion(true)
                case .failure(let error):
                    print("수정 실패" + error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
}

// MARK: - keyboard tabGesture
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

// MARK: - textView PlaceHolder
extension ArtistPortfolioEditingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text, !text.isEmpty {
            self.infoTextViewPlaceHolderLabel.isHidden = true
        } else {
            self.infoTextViewPlaceHolderLabel.isHidden = false
        }
    }
}

