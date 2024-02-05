//
//  HeaderView.swift
//  MEME
//
//  Created by 임아영 on 1/12/24.
//

import UIKit

class ModelHeaderView: UIView {
    
    weak var delegate: ModelHeaderViewDelegate?
    
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
        button.tintColor = UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 1)
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)

        return button
    }()
    
    let myPageIcon1: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.mpArtist, for: .normal)
        button.tintColor = UIColor.mainBold
        button.addTarget(self, action: #selector(mpArtistClicked(sender:)), for: .touchUpInside)

        return button
    }()

    let myPageIcon2: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.mpMakeup, for: .normal)
        button.tintColor = UIColor.mainBold
        button.addTarget(self, action: #selector(mpMakeUpClicked(sender:)), for: .touchUpInside)

        return button
    }()

    let myPageIcon3: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.mpReview, for: .normal)
        button.tintColor = UIColor.mainBold
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
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        namebutton.translatesAutoresizingMaskIntoConstraints = false
        vectorbutton.translatesAutoresizingMaskIntoConstraints = false
        myPageIcon1.translatesAutoresizingMaskIntoConstraints = false
        myPageIcon2.translatesAutoresizingMaskIntoConstraints = false
        myPageIcon3.translatesAutoresizingMaskIntoConstraints = false
        mpArtistlabel.translatesAutoresizingMaskIntoConstraints = false
        mpMakeuplabel.translatesAutoresizingMaskIntoConstraints = false
        mpReviewlabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 94),
            profileImage.heightAnchor.constraint(equalToConstant: 94),
            profileImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        addSubview(namebutton)
        namebutton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        NSLayoutConstraint.activate([
            namebutton.centerXAnchor.constraint(equalTo: centerXAnchor),
            namebutton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 33)
        ])
        
        addSubview(vectorbutton)
        NSLayoutConstraint.activate([
            vectorbutton.leadingAnchor.constraint(equalTo: namebutton.trailingAnchor, constant: 11),
            vectorbutton.centerYAnchor.constraint(equalTo: namebutton.centerYAnchor),
            vectorbutton.widthAnchor.constraint(equalToConstant: 5.9),
            vectorbutton.heightAnchor.constraint(equalToConstant: 11.92)
        ])
        
        addSubview(myPageIcon1)
        NSLayoutConstraint.activate([
            myPageIcon1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 63),
            myPageIcon1.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 207),
            myPageIcon1.widthAnchor.constraint(equalToConstant: 24),
            myPageIcon1.heightAnchor.constraint(equalToConstant: 24)
        ])

        addSubview(myPageIcon2)
        NSLayoutConstraint.activate([
            myPageIcon2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            myPageIcon2.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 207),
            myPageIcon2.widthAnchor.constraint(equalToConstant: 20.9),
            myPageIcon2.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        addSubview(myPageIcon3)
        NSLayoutConstraint.activate([
            myPageIcon3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -63),
            myPageIcon3.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 207),
            myPageIcon3.widthAnchor.constraint(equalToConstant: 20),
            myPageIcon3.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        addSubview(mpArtistlabel)
        mpArtistlabel.text = "관심 아티스트"
        mpArtistlabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        addSubview(mpMakeuplabel)
        mpMakeuplabel.text = "관심 메이크업"
        mpMakeuplabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        addSubview(mpReviewlabel)
        mpReviewlabel.text = "나의 리뷰"
        mpReviewlabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        NSLayoutConstraint.activate([
            mpArtistlabel.bottomAnchor.constraint(equalTo:bottomAnchor, constant: -18),
            mpArtistlabel.centerXAnchor.constraint(equalTo: myPageIcon1.centerXAnchor),
            
            mpMakeuplabel.topAnchor.constraint(equalTo: myPageIcon2.bottomAnchor, constant: 10),
            mpMakeuplabel.centerXAnchor.constraint(equalTo: myPageIcon2.centerXAnchor),

            mpReviewlabel.topAnchor.constraint(equalTo: myPageIcon3.bottomAnchor, constant: 10),
            mpReviewlabel.centerXAnchor.constraint(equalTo: myPageIcon3.centerXAnchor)
        ])
       
        addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -29), 
            lineView.topAnchor.constraint(equalTo: mpArtistlabel.bottomAnchor, constant: 21),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])

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
