//
//  ScheduleSegmentedControl.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum ScheduleSegmentType {
    case timeTable
    case mySchedule
}

final class ScheduleSegmentedControl: UIView {
    private lazy var timeTableLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 가능 시간"
        label.textAlignment = .center
        label.font = .pretendard(to: .regular, size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var myScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 가능 시간"
        label.textAlignment = .center
        label.font = .pretendard(to: .regular, size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var timeTableButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(nil, for: .normal)
        return button
    }()
    
    private lazy var myScheduleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(nil, for: .normal)
        return button
    }()
    
    private lazy var underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray400
        return view
    }()
    
    private lazy var selectedLine: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBold
        return view
    }()
    
    private var selectedSegment = BehaviorRelay<ScheduleSegmentType>(value: .timeTable)
    var selectedSegmentObservable: Observable<ScheduleSegmentType> {
        return selectedSegment.asObservable()
    }
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        addSubviews()
        makeConstraints()
        bindView()
    }
}

// MARK: - layout configuration
extension ScheduleSegmentedControl {
    private func addSubviews() {
        addSubViews([
            timeTableLabel,
            myScheduleLabel,
            timeTableButton,
            myScheduleButton,
            underLine,
            selectedLine
        ])
    }
    
    private func makeConstraints() {
        timeTableLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        myScheduleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        timeTableButton.snp.makeConstraints {
            $0.edges.equalTo(timeTableLabel)
        }
        
        myScheduleButton.snp.makeConstraints {
            $0.edges.equalTo(myScheduleLabel)
        }
        
        underLine.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(0.5)
            $0.height.equalTo(1)
        }
        
        selectedLine.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
    }
}

// MARK: - Binding
extension ScheduleSegmentedControl {
    private func bindView() {
        timeTableButton.rx.tap
            .withUnretained(self)
            .subscribe { (self, _) in
                self.setSegment(type: .timeTable)
            }
            .disposed(by: disposeBag)
        
        myScheduleButton.rx.tap
            .withUnretained(self)
            .subscribe { (self, _) in
                self.setSegment(type: .mySchedule)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension ScheduleSegmentedControl {
    private func setSegment(type: ScheduleSegmentType) {
        transformSelectedLine(type: type)
        selectedSegment.accept(type)
    }
    
    private func transformSelectedLine(type: ScheduleSegmentType) {
        let lineWidth = underLine.frame.width / 2
        
        UIView.animate(withDuration: 0.3) {
            if type == .mySchedule {
                self.selectedLine.transform = CGAffineTransform(translationX: lineWidth, y: 0)
            } else {
                self.selectedLine.transform = .identity
            }
        }
    }
}
