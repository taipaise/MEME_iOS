//
//  MyReviewViewController.swift
//  MEME
//
//  Created by 임아영 on 1/29/24.
//

import UIKit
import SnapKit

class MyReviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MyReviewCollectionViewCellDelegate, WrittenCollectionViewCellDelegate {    
    
    var collectionView: UICollectionView!
    var dataSource: [String] = []
    
    private let cellId = "cellId"
    private let cellId2 = "cellId2"
    
    let ProfileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.profile
        iv.layer.cornerRadius = 42 / 2
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let modelLabel = UILabel()
    
    let nameLabel = UILabel()
    
    let underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    
    private let segmentedControl: MyPageSegmentedControl = {
        let underbarInfo = UnderbarIndicator(height: 3, barColor: .mainBold, backgroundColor: .gray300)
        let control = MyPageSegmentedControl(items: ["리뷰쓰기", "작성한 리뷰"], underbarInfo: underbarInfo)
        control.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    //    func updateSegmentedControlText() {
    //        let buttonText = "리뷰쓰기(\(buttons.count))"
    //        segmentedControl.setTitle(buttonText, forSegmentAt: 0)
    //    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 88)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 327, height: 88)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(WrittenCollectionViewCell.self, forCellWithReuseIdentifier: cellId2)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 10.5, left: 0, bottom: 0, right: 0)
        
        configureUI()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        segmentedControl.selectedSegmentIndex = 0
        
        handleSegmentChange()
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
        
        ProfileImage.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ProfileImage)
        NSLayoutConstraint.activate([
            ProfileImage.widthAnchor.constraint(equalToConstant: 42),
            ProfileImage.heightAnchor.constraint(equalToConstant: 42),
            ProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            ProfileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25)
        ])
        
        view.addSubview(modelLabel)
        modelLabel.text = "모델"
        modelLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        NSLayoutConstraint.activate([
            modelLabel.leadingAnchor.constraint(equalTo: ProfileImage.trailingAnchor, constant: 7),
            modelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 37),
        ])
        
        view.addSubview(nameLabel)
        nameLabel.text = "김차차"
        nameLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: ProfileImage.trailingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 3)
        ])
        
        view.addSubview(underLineView)
        underLineView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(22)
            make.leading.equalTo(view.snp.leading).offset(25)
            make.trailing.equalTo(view.snp.trailing).offset(-25)
            make.height.equalTo(1)
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(underLineView.snp.top)
            make.leading.equalTo(view.snp.leading).offset(25)
            make.trailing.equalTo(view.snp.trailing).offset(-25)
            make.height.equalTo(46.5)
        }
        
    }
    
    class CustomCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
        
        weak var delegate: MyReviewCollectionViewCellDelegate?
        
        @objc func handleButtonPress() {
            delegate?.buttonPressed(in: self)
        }
        
        let dateLabel: UILabel = {
            let dL = UILabel()
            dL.font = UIFont.pretendard(to: .medium, size: 14)
            dL.text = "예약일 2024. 02. 16 금"
            return dL
        }()
        
        lazy var innerCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: 327, height: 88)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: "MyReviewCell")
            
            return collectionView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            innerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(dateLabel)
            contentView.addSubview(innerCollectionView)
            
            NSLayoutConstraint.activate([
                dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:33),
                dateLabel.bottomAnchor.constraint(equalTo: innerCollectionView.topAnchor, constant: -5),
                innerCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
                innerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                innerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                innerCollectionView.heightAnchor.constraint(equalToConstant: 88),
                contentView.bottomAnchor.constraint(equalTo: innerCollectionView.bottomAnchor),
            ])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyReviewCell", for: indexPath) as! MyReviewCollectionViewCell
            cell.delegate = delegate
            return cell
        }
    }
    
    class CustomCell2: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
        
        weak var delegate: WrittenCollectionViewCellDelegate?
        var indexPath: IndexPath?

        @objc func handleButtonPress() {
            if let indexPath = indexPath {
                delegate?.menubuttonPressed(in: self, at: indexPath)
            }
        }
        
        let dateLabel: UILabel = {
            let dL = UILabel()
            dL.font = UIFont.pretendard(to: .medium, size: 14)
            dL.text = "작성일 2024. 02. 16 금"
            return dL
        }()
        
        lazy var innerCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: 327, height: 88)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(WrittenCollectionViewCell.self, forCellWithReuseIdentifier: "WrittenCell")
            
            
            return collectionView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            innerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(dateLabel)
            contentView.addSubview(innerCollectionView)
            
            NSLayoutConstraint.activate([
                dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 33),
                dateLabel.bottomAnchor.constraint(equalTo: innerCollectionView.topAnchor, constant: -5),
                innerCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
                innerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                innerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                innerCollectionView.heightAnchor.constraint(equalToConstant: 88),
                contentView.bottomAnchor.constraint(equalTo: innerCollectionView.bottomAnchor),
            ])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WrittenCell", for: indexPath) as!
            WrittenCollectionViewCell
            cell.indexPath = indexPath
            cell.delegate = delegate
            return cell
        }
    }
    @objc func handleSegmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            WriteReviewView()
        case 1:
            ReviewWrittenView()
        default:
            break
        }
    }
    
    func WriteReviewView() {
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.reloadData()
    }
    
    func ReviewWrittenView() {
        collectionView.register(CustomCell2.self, forCellWithReuseIdentifier: "CustomCell2")
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        //사용자 설정에 따라 바꿔야함
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
            cell.delegate = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell2", for: indexPath) as! CustomCell2
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func buttonPressed(in cell: UICollectionViewCell) {
        navigationController?.pushViewController(WriteReviewViewController(), animated: true)
    }
    func menubuttonPressed(in cell: UICollectionViewCell, at indexPath: IndexPath) {
        print("menubuttonPressed at \(indexPath)")

        self.view.viewWithTag(100)?.removeFromSuperview()
        
        // 메뉴 뷰 생성
        let menuView = UIStackView()
        menuView.tag = 100
        menuView.axis = .vertical
        menuView.distribution = .fillEqually
        menuView.backgroundColor = .white
        menuView.layer.cornerRadius = 0
        menuView.layer.borderColor = UIColor.gray300.cgColor
        menuView.layer.borderWidth = 1
        self.view.addSubview(menuView)

        
        // "수정하기" 버튼 생성 및 설정
        let editButton = UIButton()
        editButton.setTitle("수정하기", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.addTarget(self, action: #selector(moveToReviewEditVC), for: .touchUpInside)
        
        // "삭제하기" 버튼 생성 및 설정
        let deleteButton = UIButton()
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteCollectionViewCell), for: .touchUpInside)
        deleteButton.tag = indexPath.row // 버튼의 태그에 인덱스 저장
        
        editButton.titleLabel?.font = UIFont.pretendard(to: .regular, size: 12)
        deleteButton.titleLabel?.font = UIFont.pretendard(to: .regular, size: 12)
        
        // 메뉴 뷰에 버튼 추가
        menuView.addArrangedSubview(editButton)
        menuView.addArrangedSubview(deleteButton)
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true


        // 메뉴 뷰 위치 및 크기 설정
//            let cellBottomRight = CGPoint(x: cell.bounds.width, y: cell.bounds.height)
//            let cellPosition = cell.convert(cellBottomRight, to: self.view.window)
//            menuView.frame = CGRect(x: cellPosition.x - 150, y: cellPosition.y, width: 150, height: 100)
//        menuView.center = self.view.center
        menuView.translatesAutoresizingMaskIntoConstraints = false
        let cellBottomRight = CGPoint(x: cell.bounds.width, y: cell.bounds.height)
        let cellPositionInSuperview = cell.convert(cellBottomRight, to: self.view)

        NSLayoutConstraint.activate([
            menuView.rightAnchor.constraint(equalTo: self.view.leftAnchor, constant: cellPositionInSuperview.x - 10),
            menuView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: cellPositionInSuperview.y - 30),
            menuView.widthAnchor.constraint(equalToConstant: 85),
            menuView.heightAnchor.constraint(equalToConstant: 56)
        ])

    }
    
    @objc func moveToReviewEditVC() {
//        let reviewEditVC = ReviewEditViewController()
//           reviewEditVC.reviewContent = "리뷰 내용" // 수정할 리뷰의 내용
        navigationController?.pushViewController(WriteReviewViewController(), animated: true)
    }
    
    @objc func deleteCollectionViewCell(_ sender: UIButton) {
        let index = sender.tag
      
        dataSource.remove(at: index)

        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }, completion: nil)
    }
}

class CustomSegmentedControl: UISegmentedControl {
    private var indicatorViews = [UIView]()
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        for _ in items ?? [] {
            let indicatorView = UIView()
            indicatorView.backgroundColor = .gray
            indicatorViews.append(indicatorView)
            addSubview(indicatorView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension MyReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 125)
    }
}
