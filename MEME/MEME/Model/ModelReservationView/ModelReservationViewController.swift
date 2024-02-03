//
//  ModelReservationViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit

class ModelReservationViewController: UIViewController, UIScrollViewDelegate {
    // 예시 API 호출 이미지  -> 이후 삭제 필요
    let imageUrlsFromAPI: [String] = ["https://images.unsplash.com/photo-1620613908146-bb9a8bbb7eca?q=80&w=1854&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1594465919760-441fe5908ab0?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", "https://images.unsplash.com/photo-1629297777138-6ae859d4d6df?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ]
    
    // MARK: - Properties
    private let navigationBar = NavigationBarView()
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    
    //backgroundImage 스크롤
    private lazy var backgroundImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        return scrollView
    }()
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .gray500
        pageControl.pageIndicatorTintColor = .white
        
        return pageControl
    }()
    private let defaultImage = UIImage(named: "reservation_back")
   
    
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
        imageView.isUserInteractionEnabled = true
        
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
        imageView.isUserInteractionEnabled = true
        
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
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 0
        
        return stack
    }()
    
    private let segmentedControl: ModelReservationSegmentedControl = {
        let underbarInfo = UnderbarInfo(height: 3, barColor: .mainBold, backgroundColor: .gray300)
        let control = ModelReservationSegmentedControl(items: ["정보", "리뷰"], underbarInfo: underbarInfo)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    private var informationView = ShowInformationView()
    private var reviewView = ShowReviewView()
    
    private var underBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 6)
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.1).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        view.layer.insertSublayer(gradient, at: 0)
        
        return view
    }()
    private let reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("예약하기", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(reservationTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.delegate = self
        navigationBar.configure(title: "예약하기")
        
        fetchImagesFromAPI()
        setupSegmentedControl()

        configureSubviews()
        makeConstraints()
        
        setupGestureRecognizers()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        backgroundImageScrollView.delegate = self
        contentsView.addSubview(backgroundImageScrollView)
        contentsView.addSubview(pageControl)
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
        contentsView.addSubview(mainStackView)
        view.addSubview(underBarView)
        view.addSubview(reservationButton)
    }
    

    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBar.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        backgroundImageScrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentsView)
            make.height.equalTo(contentsView.snp.width)
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentsView.snp.centerX)
            make.top.equalTo(backgroundImageScrollView.snp.bottom).offset(-70)
        }
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImageScrollView.snp.bottom).offset(-31)
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
            make.top.equalTo(underLineView.snp.top)
            make.leading.equalTo(contentsView.snp.leading).offset(25)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(35)
        }
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.equalTo(contentsView.snp.leading).offset(25)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.bottom.equalTo(contentsView.snp.bottom).offset(-100)
        }
        underBarView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(61)
        }
        reservationButton.snp.makeConstraints { (make) in
            make.top.equalTo(underBarView.snp.top).offset(12)
            make.leading.equalTo(underBarView.snp.leading).offset(26)
            make.trailing.equalTo(underBarView.snp.trailing).offset(-26)
            make.height.equalTo(50)
        }
    }
    // MARK: - Action
    @objc func pageControlChanged(_ sender: UIPageControl) {
        let current = sender.currentPage
        backgroundImageScrollView.setContentOffset(CGPoint(x: CGFloat(current) * backgroundImageScrollView.frame.size.width, y: 0), animated: true)
    }
    private func setupGestureRecognizers() {
        setupTapGestureRecognizer(for: profileImageView, withSelector: #selector(profileImageTapped))
        setupTapGestureRecognizer(for: likeImageView, withSelector: #selector(likeImageTapped))
    }
    private func setupTapGestureRecognizer(for view: UIView, withSelector selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    @objc private func reservationTapped() {
        let reservationsVC = ModelReservationDetailViewController()
        navigationController?.pushViewController(reservationsVC, animated: true)
    }
    @objc private func profileImageTapped() {
        let artistProfileVC = ModelViewArtistProfileViewController()
        navigationController?.pushViewController(artistProfileVC, animated: true)
    }
    @objc private func likeImageTapped() {
        if likeImageView.image == UIImage(named: "icon_like") {
            likeImageView.image = UIImage(named: "icon_fillLike")
        } else {
            likeImageView.image = UIImage(named: "icon_like")
        }
    }
    // MARK: - API Actions
    private func fetchImagesFromAPI() {
        if imageUrlsFromAPI.isEmpty {
            addImageView(image: defaultImage!, index: 0)
        } else {
            for (index, urlString) in imageUrlsFromAPI.enumerated() {
                guard let url = URL(string: urlString) else { continue }
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let data = data, error == nil, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.addImageView(image: image, index: index)
                        }
                    }
                }.resume()
            }
        }
    }
    
    // MARK: - Methods
    private func addImageView(image: UIImage, index: Int) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        backgroundImageScrollView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(backgroundImageScrollView.snp.width)
            make.top.bottom.equalTo(backgroundImageScrollView)
            make.left.equalTo(backgroundImageScrollView.snp.left).offset(CGFloat(index) * contentsView.frame.size.width)
        }
        
        if index == 0 {
            backgroundImageScrollView.contentSize = CGSize(width: contentsView.frame.width * CGFloat(imageUrlsFromAPI.count), height: contentsView.frame.width)
            pageControl.numberOfPages = imageUrlsFromAPI.count
            pageControl.isHidden = imageUrlsFromAPI.count <= 1
        }
    }
    @objc private func didChangeValue(segment: UISegmentedControl) {
        updateStackView(forSegmentIndex: segment.selectedSegmentIndex)
    }

    private func updateStackView(forSegmentIndex index: Int) {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        switch index {
        case 0:
            mainStackView.addArrangedSubview(informationView)
        case 1:
            mainStackView.addArrangedSubview(reviewView)
        default:
            break
        }
    }

    //MARK: -Helpers
    private func setupSegmentedControl() {
        self.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
    }
}

// MARK: -BackButtonTappedDelegate
extension ModelReservationViewController: BackButtonTappedDelegate  {
    func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
