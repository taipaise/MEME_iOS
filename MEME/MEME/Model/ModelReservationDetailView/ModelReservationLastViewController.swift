//
//  ModelReservationLastViewController.swift
//  MEME
//
//  Created by 정민지 on 1/25/24.
//

import UIKit
import SnapKit

class ModelReservationLastViewController: UIViewController {
    // MARK: - Properties
    private var backgrounImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "img_lastReservation"))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var completeLabel: UILabel = {
        let label = UILabel()
        label.text = "김리타님,\n예약이 완료되었습니다!"
        label.font = .pretendard(to: .bold, size: 22)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    private var backgroundColorView: UIView = {
        let UIView = UIView()
        UIView.backgroundColor = UIColor(red: 244.0/255.0, green: 246.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        UIView.layer.cornerRadius = 20
        
        return UIView
    }()
    private var makeupNameLabel: UILabel = {
        let label = UILabel()
        label.text = "면접 프리패스상 메이크업"
        label.font = .pretendard(to: .semiBold, size: 18)
        label.textColor = .black
        
        return label
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트명"
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var reservationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "0월 0일 0요일 00:00시"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .mainBold
        
        return label
    }()
    private var reservationArtistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "차차"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var reservationLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 강남구"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    private let reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBold
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        configureSubviews()
        makeConstraints()
    }
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(backgrounImageView)
        view.addSubview(completeLabel)
        view.addSubview(backgroundColorView)
        view.addSubview(makeupNameLabel)
        view.addSubview(dateLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(locationLabel)
        view.addSubview(reservationDateLabel)
        view.addSubview(reservationArtistNameLabel)
        view.addSubview(reservationLocationLabel)
        view.addSubview(reservationButton)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        backgrounImageView.snp.makeConstraints { (make) in
            make.centerY.leading.trailing.equalToSuperview()
            make.height.equalTo(backgrounImageView.snp.width).multipliedBy(382.34 / 338.2)
        }
        completeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgrounImageView.snp.top).offset(-18.5)
            make.leading.equalToSuperview().offset(30)
        }
        backgroundColorView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(157)
        }
        makeupNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundColorView.snp.top).offset(17)
            make.leading.equalTo(backgroundColorView.snp.leading).offset(22)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(makeupNameLabel.snp.bottom).offset(15)
            make.leading.equalTo(backgroundColorView.snp.leading).offset(25)
        }
        artistNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.leading.equalTo(backgroundColorView.snp.leading).offset(25)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(15)
            make.leading.equalTo(backgroundColorView.snp.leading).offset(25)
        }
        reservationDateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.trailing.equalTo(backgroundColorView.snp.trailing).offset(-23)
        }
        reservationArtistNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(artistNameLabel.snp.centerY)
            make.trailing.equalTo(backgroundColorView.snp.trailing).offset(-23)
        }
        reservationLocationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(locationLabel.snp.centerY)
            make.trailing.equalTo(backgroundColorView.snp.trailing).offset(-23)
        }
        reservationButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
    }
    
}

