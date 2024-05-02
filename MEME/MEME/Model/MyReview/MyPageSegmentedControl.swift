//
//  MyPageSegmentedControl.swift
//  MEME
//
//  Created by 임아영 on 1/29/24.
//

import UIKit
import SnapKit

struct UnderbarIndicator{
  var height: CGFloat
  var barColor: UIColor
  var backgroundColor: UIColor
}

final class MyPageSegmentedControl: UISegmentedControl {

    // MARK: - Properties
    private lazy var underbar: UIView = makeUnderbar()

    private lazy var underbarWidth: CGFloat? = bounds.size.width / CGFloat(numberOfSegments)

    private var underbarInfo: UnderbarIndicator
    
    private var isFirstSettingDone = false
    
    private lazy var reviewNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(to: .regular, size: 14)

        return label
      }()

    // MARK: - Lifecycle
    init(frame: CGRect, underbarInfo info: UnderbarIndicator) {
        self.underbarInfo = info
        super.init(frame: frame)
        configureUI()
    }

    init(items: [Any]?, underbarInfo info: UnderbarIndicator) {
        self.underbarInfo = info
        super.init(items: items)
        configureUI()
        selectedSegmentIndex = 0
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !isFirstSettingDone {
            isFirstSettingDone.toggle()
            setUnderbarMovableBackgroundLayer()
            setReviewNumLabelInSegmentedViews()
            layer.cornerRadius = 0
            layer.masksToBounds = false
        }
        let underBarLeadingSpacing = CGFloat(selectedSegmentIndex) * (underbarWidth ?? 50)
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseOut, animations: {
            self.underbar.transform = .init(translationX: underBarLeadingSpacing, y: 0)
        })
    }
}


// MARK: - Private Helpers
private extension MyPageSegmentedControl {
    func configureUI() {
        removeBorders()
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]

        setTitleTextAttributes(textAttributes, for: .normal)
        setTitleTextAttributes(textAttributes, for: .selected)
        selectedSegmentTintColor = .clear
    }

    func setUnderbarMovableBackgroundLayer() {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = .init(
            x: 0,
            y: bounds.height - underbarInfo.height,
            width: bounds.width,
            height: underbarInfo.height)
        backgroundLayer.backgroundColor = underbarInfo.backgroundColor.cgColor
        backgroundLayer.cornerRadius = underbarInfo.height/2
        layer.addSublayer(backgroundLayer)
    }
    
    func setReviewNumLabelInSegmentedViews() {
        let titles = (0..<numberOfSegments).map {
            titleForSegment(at: $0)
        }
        
        let segmentedTitleLabels = subviews
            .compactMap { subview in
                subview.subviews.compactMap { $0 as? UILabel }
            }
            .flatMap { $0 }
            .sorted {
                guard
                    let idx1 = titles.firstIndex(of: $0.text ?? ""),
                    let idx2 = titles.firstIndex(of: $1.text ?? "")
                else { return false }
                return idx1 < idx2
            }
        
        for (index, title) in titles.enumerated() {
            if let segmentLabel = segmentedTitleLabels.first(where: { $0.text == title }) {
                
                segmentLabel.addSubview(reviewNumLabel)
                reviewNumLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(segmentLabel.snp.centerY)
                    make.leading.equalTo(segmentLabel.snp.trailing).offset(5)
                }
            }
        }
    }
    
    func makeUnderbar() -> UIView {
        let underbar = UIView(frame: .zero)
        underbar.translatesAutoresizingMaskIntoConstraints = false
        underbar.backgroundColor = underbarInfo.barColor
        underbar.layer.cornerRadius = underbarInfo.height/2
        addSubview(underbar)
        underbar.snp.makeConstraints { make in // SnapKit을 사용한 제약 조건 설정
            make.leading.equalTo(self.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(underbarWidth ?? 50)
            make.height.equalTo(underbarInfo.height)
        }
        return underbar
    }
    
    func removeBorders() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}
