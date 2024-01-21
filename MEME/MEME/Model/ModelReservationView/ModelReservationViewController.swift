//
//  ModelReservationViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit

class ModelReservationViewController: UIViewController {
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
        
        return UIView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
        }
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(contentsView.snp.top)
            make.leading.trailing.equalTo(contentsView)
            make.height.equalTo(backgroundImageView.snp.width)
        }
        backgroundView.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(backgroundImageView.snp.bottom).offset(-31)
            make.leading.trailing.equalTo(contentsView)
            make.bottom.equalTo(contentsView.snp.bottom)
        }
    }
    
    
    
  
}
