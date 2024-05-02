//
//  HeaderView.swift
//  MEME
//
//  Created by 임아영 on 1/12/24.
//

import UIKit
import SnapKit

class ModelHeaderView: UIView {
    
    weak var delegate: ModelHeaderViewDelegate?
    var data: MyPageResponse?

    // MARK: - Properties
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.profile
        iv.layer.cornerRadius = 94 / 2
        iv.clipsToBounds = true
       
        return iv
    }()
    
    let namebutton: UIButton = {
        let button = UIButton()
        button.setTitle("차차", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)

        return button
    }()

    let vectorbutton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.icRightArrow, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)

        return button
    }()
    
    let myPageIcon1: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.mpArtist, for: .normal)
        button.tintColor = .mainBold
        button.addTarget(self, action: #selector(mpArtistClicked(sender:)), for: .touchUpInside)

        return button
    }()

    let myPageIcon2: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.mpMakeup, for: .normal)
        button.tintColor = .mainBold
        button.addTarget(self, action: #selector(mpMakeUpClicked(sender:)), for: .touchUpInside)

        return button
    }()

    let myPageIcon3: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.mpReview, for: .normal)
        button.tintColor = .mainBold
        button.addTarget(self, action: #selector(myReviewClicked(sender:)), for: .touchUpInside)

        return button
    }()

    lazy var mpArtistlabel: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mpArtistClicked(sender:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
            
        return label
    }()
    
    lazy var mpMakeuplabel: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mpMakeUpClicked(sender:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
            
        return label
    }()
    
    lazy var mpReviewlabel: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myReviewClicked(sender:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
            
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray500

        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(94)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        addSubview(namebutton)
        namebutton.titleLabel?.font = .pretendard(to: .semiBold, size: 18)
        namebutton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImage.snp.bottom).offset(33)
        }
        
        addSubview(vectorbutton)
        vectorbutton.snp.makeConstraints { make in
            make.leading.equalTo(namebutton.snp.trailing).offset(11)
            make.centerY.equalTo(namebutton.snp.centerY)
            make.width.equalTo(5.9)
            make.height.equalTo(11.92)
        }
        
        addSubview(myPageIcon1)
        myPageIcon1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(63)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(207)
            make.width.height.equalTo(24)
        }

        addSubview(myPageIcon2)
        myPageIcon2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(207)
            make.width.equalTo(20.9)
            make.height.equalTo(17)
        }
        
        addSubview(myPageIcon3)
        myPageIcon3.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-63)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(207)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
            
        addSubview(mpArtistlabel)
        mpArtistlabel.text = "관심 아티스트"
        mpArtistlabel.font = .pretendard(to: .regular, size: 12)
        mpArtistlabel.textColor = .black
        mpArtistlabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-18)
            make.centerX.equalTo(myPageIcon1.snp.centerX)
        }
            
        addSubview(mpMakeuplabel)
        mpMakeuplabel.text = "관심 메이크업"
        mpMakeuplabel.font = .pretendard(to: .regular, size: 12)
        mpMakeuplabel.textColor = .black
        mpMakeuplabel.snp.makeConstraints { make in
            make.top.equalTo(myPageIcon2.snp.bottom).offset(10)
            make.centerX.equalTo(myPageIcon2.snp.centerX)
        }
            
        addSubview(mpReviewlabel)
        mpReviewlabel.text = "나의 리뷰"
        mpReviewlabel.font = .pretendard(to: .regular, size: 12)
        mpReviewlabel.textColor = .black
        mpReviewlabel.snp.makeConstraints { make in
            make.top.equalTo(myPageIcon3.snp.bottom).offset(10)
            make.centerX.equalTo(myPageIcon3.snp.centerX)
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(26)
            make.trailing.equalToSuperview().offset(-29)
            make.top.equalTo(mpArtistlabel.snp.bottom).offset(21)
            make.height.equalTo(1)
        }
        
        MyPageManager.shared.getMyPageProfile(userId: KeyChainManager.loadMemberID()) { [weak self] result in
            switch result {
            case .success(let response):
                self?.data = response
                
                DispatchQueue.main.async {
                    if let nickname = response.data?.nickname {
                        self?.namebutton.setTitle(nickname, for: .normal)
                    }
                    if let profileImgUrl = response.data?.profileImg {
                        self?.profileImage.loadImage(from: profileImgUrl)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

@objc func buttonClicked(sender: UIButton) {
        delegate?.buttonClicked()
    }
    
@objc func mpArtistClicked(sender: UIView) {
        delegate?.mpArtistClicked()
    }
@objc func mpMakeUpClicked(sender: UIView) {
        delegate?.mpMakeUpClicked()
    }
@objc func myReviewClicked(sender: UIView) {
        delegate?.myReviewClicked()
    }
}

protocol ModelHeaderViewDelegate: AnyObject {
    func buttonClicked()
    func mpArtistClicked()
    func mpMakeUpClicked()
    func myReviewClicked()
}
