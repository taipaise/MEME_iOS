//
//  File.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import Foundation

class CompositeView: UIView {
    private let view1 = UIView()
    private let view2 = UIView()
    private let view3 = UIView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Setup
    private func commonInit() {
        addSubview(view1)
        addSubview(view2)
        addSubview(view3)
        
        // 여기에서 각 뷰의 오토레이아웃을 설정합니다.
    }
}

// 뷰 컨트롤러에서 사용
class ViewController: UIViewController {
    private let compositeView = CompositeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(compositeView)
        
        // Auto Layout Constraints 설정
        compositeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compositeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            compositeView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            compositeView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            compositeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
