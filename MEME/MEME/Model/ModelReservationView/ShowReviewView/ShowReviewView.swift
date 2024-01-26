//
//  ShowReviewView.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit
// 예시 데이터 구조 -> 이후 삭제 필요
struct ReviewData {
    var profileImage: UIImage?
    var profileName: String
    var starRate: String
    var reviewText: String
    var reviewImages: [UIImage]
}

class ShowReviewView: UIView {
    // 예시 데이터 배열 -> 이후 삭제 필요
    
    var reviews: [ReviewData] = [
        ReviewData(profileImage: UIImage(named: "modelProfile"),
                   profileName: "메메**",
                   starRate: "5",
                   reviewText: "후기 작성 칸 후기 작성 칸\n후기후기",
                   reviewImages: [UIImage(named: "img_exReview1"), UIImage(named: "img_exReview2")].compactMap { $0 }),
        ReviewData(profileImage: UIImage(named: "modelProfile"),
                   profileName: "차*",
                   starRate: "1",
                   reviewText: "후기 작성 칸 후기 작성 칸\n후기후기",
                   reviewImages: []),
        ReviewData(profileImage: UIImage(named: "modelProfile"),
                   profileName: "리*",
                   starRate: "4",
                   reviewText: "후기 작성 칸 후기 작성 칸\n후기후기",
                   reviewImages: [UIImage(named: "img_exReview3")].compactMap { $0 })
    ]
    
    // MARK: - Properties
    private var totalStarRatingView = TotalStarRatingView()
    private var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray200
        
        return lineView
    }()
    private var reviewTableView: UITableView!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let sampleData = StarRatingDistribution(fiveStars: 50, fourStars: 30, threeStars: 15, twoStars: 3, oneStar: 2)
        totalStarRatingView.update(with: sampleData)
        
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
            make.height.equalTo(700)
            make.bottom.equalToSuperview()
        }
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
    //cell의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //api 호출 한 수 만큼 수정
        return 3
    }
    
    //cell의 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowReviewTableViewCell", for: indexPath) as? ShowReviewTableViewCell else {
            fatalError("셀 타입 캐스팅 실패...")
        }
        cell.selectionStyle = .none
        let review = reviews[indexPath.row]
        cell.configure(profileImage: review.profileImage,
                       profileName: review.profileName,
                       starRate: review.starRate,
                       reviewImages: review.reviewImages,
                       reviewText: review.reviewText
                       )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
}

