//
//  ArtistPortfolioEditingViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/28/24.
//

import UIKit

class ArtistPortfolioEditingViewController: UIViewController {
    //MARK: - UI Properties
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
    
    //MARK: - ViewController 생명 주기
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
    }
    
    //MARK: - setUI()
    private func setUI(){
        makeupCategoryCollectionView.backgroundColor = .white
        infoTextView.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        infoTextView.delegate = self
        infoTextView.layer.cornerRadius = 10
        infoTextView.layer.borderWidth = 1
        infoTextView.layer.borderColor = UIColor.gray200.cgColor
        
        priceTextField.keyboardType = .numberPad
        if portfolioId == -1 {
            artistProfileEditingInfoBar.setTitle("수정하기", for: .normal)
            self.navigationItem.title = "포트폴리오 수정"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: .icTrash.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(trashButtonDidTap))
        }else {
            self.navigationItem.title =  "포트폴리오 추가"
            artistProfileEditingInfoBar.setTitle("추가하기", for: .normal)
        }
    }
    
    //MARK: - collectionViewConfigure()
    private func collectionViewConfigure(){
        makeupCategoryCollectionView.delegate = self
        makeupCategoryCollectionView.dataSource = self
        makeupCategoryCollectionView.register(UINib(nibName: ArtistMakeupTagCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ArtistMakeupTagCollectionViewCell.className)
        portfolioImageCollectionView.delegate = self
        portfolioImageCollectionView.dataSource = self
        portfolioImageCollectionView.register(PortfolioImageCollectionViewCell.self, forCellWithReuseIdentifier: PortfolioImageCollectionViewCell.className)
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
    
    //MARK: - @IBAction
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        var title = ""
        var message = ""
        
        if portfolioId == -1 {
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
        let okAction: UIAlertAction
        var title = ""
        var message = ""
        
        if portfolioId == -1 {
            title = "포트폴리오 수정하기"
            message = "\n포트폴리오를 수정하시겠습니까?"
            okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
                // TODO: 포트폴리오 수정
            }
        } else {
            title = "포트폴리오 등록하기"
            message = "\n포트폴리오를 등록하시겠습니까?"
            okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
                // TODO: 포트폴리오 생성
            }
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func trashButtonDidTap(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "포트폴리오 삭제하기", message: "\n포트폴리오를 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.isBlock=true
            // TODO: 포트폴리오 삭제
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
}

//MARK: - UICollectionViewDataSource
extension ArtistPortfolioEditingViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == makeupCategoryCollectionView{
            return portfolioCategories.count
        }else {
            return 4
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == makeupCategoryCollectionView {
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
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioImageCollectionViewCell.className, for: indexPath) as? PortfolioImageCollectionViewCell else { return UICollectionViewCell() }
            // 이미지 설정
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension ArtistPortfolioEditingViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == makeupCategoryCollectionView {
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
        } else {
            //TODO: 이미지 변경 혹은 추가
            if indexPath.row == 0 {
                
            }else {
                
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
        }else {
            return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        }
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

//MARK: - API 호출
extension ArtistPortfolioEditingViewController {
    private func getPortfolioDetail() {
        
    }
    
    private func createPortfolio(){
        
    }
    
    private func editPortfolio() {
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

extension ArtistPortfolioEditingViewController: PortfolioImageCollectionViewCellDelegate {
    func deleteButtonTapped() {
        //TODO: 삭제 후 콜렉션 뷰 새로고침
    }
}
