//
//  ModelReservationViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit

class ModelReservationViewController: UIViewController, BackButtonTappedDelegate {
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reservation_back")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var backgroundView: UIView = {
        let UIView = UIView()
        UIView.backgroundColor = .white
        UIView.layer.cornerRadius = 17
        
        return UIView
    }()
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "modelProfile")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "김차차"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_like")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_share")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var makeupNameLabel: UILabel = {
        let label = UILabel()
        label.text = "촬영 메이크업"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 16)
        
        return label
    }()
    private var makeupExplainLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필사진 촬영에 좋아요"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 12)
        
        return label
    }()
    private var makeupPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "100,000"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var topLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    private var qEmploymentStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "샵 재직 여부"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 14)
        
        return label
    }()
    private var aEmploymentStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "🙅🏻프리랜서에요"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private var qCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 14)
        
        return label
    }()
    private var aCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "면접 메이크업"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private var underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    private let segmentedControl: ModelReservationSegmentedControl = {
        let underbarInfo = UnderbarInfo(height: 3, barColor: .mainBold, backgroundColor: .gray300)
        let control = ModelReservationSegmentedControl(items: ["정보", "리뷰"], underbarInfo: underbarInfo)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    let verticalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical // 수직 스택 뷰로 설정
            stackView.alignment = .leading // 정렬 방식 설정 (예: .leading, .center, .trailing)
            stackView.distribution = .fill // 요소 간 간격을 균등하게 배분
            stackView.spacing = 8 // 요소 사이의 간격 설정
            return stackView
        }()
    private var informationView = InformationView()
    private var reviewView = ReviewView()
    private var shouldHideInformationView: Bool? {
        didSet {
          guard let shouldHideInformationView = self.shouldHideInformationView else { return }
          self.informationView.isHidden = shouldHideInformationView
          self.reviewView.isHidden = !self.informationView.isHidden
        }
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCustomNavigationBar()
        setupSegmentedControl()
        configureSubviews()
        makeConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let path = UIBezierPath(roundedRect: backgroundView.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 17, height: 17))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        backgroundView.layer.mask = maskLayer
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(backgroundImageView)
        contentsView.addSubview(backgroundView)
        contentsView.addSubview(profileImageView)
        contentsView.addSubview(artistNameLabel)
        contentsView.addSubview(likeImageView)
        contentsView.addSubview(shareImageView)
        contentsView.addSubview(makeupNameLabel)
        contentsView.addSubview(makeupExplainLabel)
        contentsView.addSubview(makeupPriceLabel)
        contentsView.addSubview(topLineView)
        contentsView.addSubview(qEmploymentStatusLabel)
        contentsView.addSubview(aEmploymentStatusLabel)
        contentsView.addSubview(qCategoryLabel)
        contentsView.addSubview(aCategoryLabel)
        contentsView.addSubview(underLineView)
        contentsView.addSubview(segmentedControl)
        contentsView.addSubview(informationView)
        contentsView.addSubview(reviewView)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentsView.snp.top)
            make.leading.equalTo(contentsView.snp.leading)
            make.trailing.equalTo(contentsView.snp.trailing)
            make.height.equalTo(backgroundImageView.snp.width)
        }
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(-31)
            make.leading.equalTo(contentsView.snp.leading)
            make.trailing.equalTo(contentsView.snp.trailing)
            make.bottom.equalTo(contentsView.snp.bottom)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView.snp.top).offset(31)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
            make.width.equalTo(52)
            make.height.equalTo(52)
        }
        artistNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo( profileImageView.snp.trailing).offset(16)
        }
        shareImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo( contentsView.snp.trailing).offset(-39)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        likeImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo( shareImageView.snp.leading).offset(-16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        makeupNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
        }
        makeupExplainLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(makeupNameLabel.snp.centerY)
            make.leading.equalTo(makeupNameLabel.snp.trailing).offset(22)
        }
        makeupPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(makeupNameLabel.snp.bottom).offset(11)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
        }
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(makeupPriceLabel.snp.bottom).offset(23)
            make.leading.equalTo(contentsView.snp.leading).offset(14)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-14)
            make.height.equalTo(1)
        }
        qEmploymentStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(20)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
        }
        aEmploymentStatusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(qEmploymentStatusLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-44)
        }
        qCategoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(qEmploymentStatusLabel.snp.bottom).offset(11)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
        }
        aCategoryLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(qCategoryLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-44)
        }
        underLineView.snp.makeConstraints { (make) in
            make.top.equalTo(qCategoryLabel.snp.bottom).offset(20)
            make.leading.equalTo(contentsView.snp.leading).offset(14)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-14)
            make.height.equalTo(1)
        }
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(underLineView.snp.bottom)
            make.leading.equalTo(contentsView.snp.leading).offset(14)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-14)
            make.height.equalTo(35)
        }
        informationView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(2)
            make.leading.equalTo(contentsView.snp.leading).offset(14)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-14)
            make.height.equalTo(100)
        }
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(2)
            make.leading.equalTo(contentsView.snp.leading).offset(14)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-14)
            make.height.equalTo(400)
        }
    }
    // MARK: - Action
    func backButtonTapped() {
            self.navigationController?.popViewController(animated: true)
        }
    // MARK: - Methods
      @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideInformationView = segment.selectedSegmentIndex != 0
      }
    
    //MARK: -Helpers
    private func setupCustomNavigationBar() {
        let navigationBarView = NavigationBarView()
        navigationBarView.delegate = self
        navigationBarView.configure(title: "뒤로")
        let leftBarButtonItem = UIBarButtonItem(customView: navigationBarView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    private func setupSegmentedControl() {
        self.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
    }
}


