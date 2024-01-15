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
        iv.image = UIImage()
        iv.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        iv.layer.cornerRadius = 117 / 2
        iv.clipsToBounds = true
        
        let label = UILabel()
        label.text = "profile \nimage"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        iv.addSubview(label)
        
        NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: iv.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: iv.centerYAnchor)
            ])

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
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 1)
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)

        return button
    }()
    
    let myPageIcon1: UIButton = {
        let button = UIButton(type: .system)
        let imageView = UIImageView(image: UIImage(systemName: "square.fill"))
        imageView.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        button.addSubview(imageView)
        
        return button
    }()

    let myPageIcon2: UIButton = {
        let button = UIButton(type: .system)
        let imageView = UIImageView(image: UIImage(systemName: "square.fill"))
        imageView.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        button.addSubview(imageView)
        
        return button
    }()

    let myPageIcon3: UIButton = {
        let button = UIButton(type: .system)
        let imageView = UIImageView(image: UIImage(systemName: "square.fill"))
        imageView.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        button.addSubview(imageView)
        
        return button
    }()

    
    let grayBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let mpArtistlabel = UILabel()
    let mpMakeuplabel = UILabel()
    let mpReviewlabel = UILabel()
    
    
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
        grayBackground.translatesAutoresizingMaskIntoConstraints = false
        mpArtistlabel.translatesAutoresizingMaskIntoConstraints = false
        mpMakeuplabel.translatesAutoresizingMaskIntoConstraints = false
        mpReviewlabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 117),
            profileImage.heightAnchor.constraint(equalToConstant: 117),
            profileImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 26)
        ])
        
        addSubview(namebutton)
        namebutton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
        NSLayoutConstraint.activate([
            namebutton.centerXAnchor.constraint(equalTo: centerXAnchor),
            namebutton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15),
        ])
        
        addSubview(vectorbutton)
        NSLayoutConstraint.activate([
            vectorbutton.leadingAnchor.constraint(equalTo: namebutton.trailingAnchor, constant: 10),
            vectorbutton.centerYAnchor.constraint(equalTo: namebutton.centerYAnchor),
            vectorbutton.widthAnchor.constraint(equalToConstant: 9),
            vectorbutton.heightAnchor.constraint(equalToConstant: 11.92)
        ])
        
        let buttonSize: CGFloat = 38
        let backgroundPadding: CGFloat = 14
        let sidePadding: CGFloat = 37.5
        
        addSubview(grayBackground)
        NSLayoutConstraint.activate([
            grayBackground.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 0),
            grayBackground.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 199),
            grayBackground.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            grayBackground.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),
            grayBackground.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -19)
        ])

        addSubview(myPageIcon1)
        NSLayoutConstraint.activate([
            myPageIcon1.topAnchor.constraint(equalTo: grayBackground.topAnchor, constant: backgroundPadding),
            myPageIcon1.leadingAnchor.constraint(equalTo: grayBackground.leadingAnchor, constant: sidePadding),
            myPageIcon1.widthAnchor.constraint(equalToConstant: buttonSize),
            myPageIcon1.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        addSubview(myPageIcon2)
        myPageIcon2.contentHorizontalAlignment = .center
        NSLayoutConstraint.activate([
            myPageIcon2.topAnchor.constraint(equalTo: grayBackground.topAnchor, constant: backgroundPadding),
            myPageIcon2.centerXAnchor.constraint(equalTo: grayBackground.centerXAnchor),
            myPageIcon2.widthAnchor.constraint(equalToConstant: buttonSize),
            myPageIcon2.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        addSubview(myPageIcon3)
        NSLayoutConstraint.activate([
            myPageIcon3.topAnchor.constraint(equalTo: grayBackground.topAnchor, constant: backgroundPadding),
            myPageIcon3.trailingAnchor.constraint(equalTo: grayBackground.trailingAnchor, constant: -sidePadding),
            myPageIcon3.widthAnchor.constraint(equalToConstant: buttonSize),
            myPageIcon3.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        addSubview(mpArtistlabel)
        mpArtistlabel.text = "관심 아티스트"
        mpArtistlabel.font = UIFont.systemFont(ofSize: 12)
        
        addSubview(mpMakeuplabel)
        mpMakeuplabel.text = "관심 메이크업"
        mpMakeuplabel.font = UIFont.systemFont(ofSize: 12)
        
        addSubview(mpReviewlabel)
        mpReviewlabel.text = "내가 쓴 리뷰"
        mpReviewlabel.font = UIFont.systemFont(ofSize: 12)
        
        NSLayoutConstraint.activate([
            mpArtistlabel.topAnchor.constraint(equalTo: myPageIcon1.bottomAnchor, constant: 6),
            mpArtistlabel.centerXAnchor.constraint(equalTo: myPageIcon1.centerXAnchor),
            
            mpMakeuplabel.topAnchor.constraint(equalTo: myPageIcon2.bottomAnchor, constant: 6),
            mpMakeuplabel.centerXAnchor.constraint(equalTo: myPageIcon2.centerXAnchor),

            mpReviewlabel.topAnchor.constraint(equalTo: myPageIcon3.bottomAnchor, constant: 6),
            mpReviewlabel.centerXAnchor.constraint(equalTo: myPageIcon3.centerXAnchor)
        ])
        
    }
    
//버튼 클릭 시 메서드 추가
//    @objc func buttonClicked(sender: UIButton) {
//        let MyPageInfoViewController = MyPageInfoViewController()
//        self.navigationController?.pushViewController(MyPageInfoViewController, animated: true)
//    }

@objc func buttonClicked(sender: UIButton) {
        delegate?.buttonClicked()
    }
}

protocol ModelHeaderViewDelegate: AnyObject {
    func buttonClicked()
}
