//
//  ShowReviewView.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit

struct ReviewData {
    var modelName: String
    var star: Int
    var comment: String
    var reviewImgDtoList: [UIImage]
}

class ShowReviewView: UIView {
    var reviews: [ReviewData] = []
    
    // MARK: - Properties
    private var totalStarRatingView = TotalStarRatingView()
    private var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray200
        
        return lineView
    }()
    public var reviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = false
        
        return tableView
    }()
    var innerScrollView: UIScrollView {
        reviewTableView
    }
    var innerScrollingDownDueToOuterScroll = false
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupReviewTableView()
        configureSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    private func configureSubviews() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalStarRatingView)
        addSubview(lineView)
        reviewTableView.backgroundColor = .white
        addSubview(reviewTableView)
    }
    
    // MARK: - makeConstraints
    private func makeConstraints() {
        totalStarRatingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(166)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(totalStarRatingView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        reviewTableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
            make.bottom.equalToSuperview()
        }
    }
    func updateReviews(with newData: [ReviewData], starRatingDistribution: StarRatingDistribution) {
        self.reviews = newData
        self.totalStarRatingView.update(with: starRatingDistribution)
        reviewTableView.reloadData()
    }

    
    //MARK: -Helpers
    private func setupReviewTableView() {
        reviewTableView = UITableView()
        
        //delegate 연결
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        //cell 등록
        reviewTableView.register(ShowReviewTableViewCell.self, forCellReuseIdentifier: "ShowReviewTableViewCell")
    }
}

//MARK: -UITableViewDataSource, UITableViewDelegate
extension ShowReviewView: UITableViewDataSource, UITableViewDelegate {
    enum Policy {
        static let floatingPointTolerance = 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    //cell의 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowReviewTableViewCell", for: indexPath) as? ShowReviewTableViewCell else {
            fatalError("셀 타입 캐스팅 실패...")
        }
        cell.selectionStyle = .none
        let review = reviews[indexPath.row]
        cell.configure(modelName: review.modelName,
                       star: review.star,
                       comment: review.comment,
                       reviewImgDtoList: review.reviewImgDtoList
                       )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
}

