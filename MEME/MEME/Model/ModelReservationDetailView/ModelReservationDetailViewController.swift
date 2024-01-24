//
//  ModelReservationDetailViewController.swift
//  MEME
//
//  Created by 정민지 on 1/24/24.
//

import UIKit
import SnapKit
import FSCalendar

class ModelReservationDetailViewController: UIViewController {
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    private var manualLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 정보를 알려주세요."
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var selectDateLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 날짜를 선택해주세요."
        label.textColor = .black
        label.font = .pretendard(to: .medium, size: 14)
        
        return label
    }()
    // 현재 캘린더가 보여주고 있는 Page 트래킹
    lazy var currentPage = calendarView.currentPage
    
    // 이전 달로 이동 버튼
    private let prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    
    // 다음 달로 이동 버튼
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.firstWeekday = 2
        calendar.scope = .month
        calendar.backgroundColor = .white
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 헤더뷰 설정
        calendar.headerHeight = 40
        calendar.appearance.headerDateFormat = "YYYY. M"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = .pretendard(to: .semiBold, size: 20)
        calendar.appearance.headerTitleAlignment = .center
        
        // 요일 설정
        calendar.appearance.weekdayFont = .pretendard(to: .semiBold, size: 18)
        calendar.appearance.weekdayTextColor = .black
        
        // 날짜 설정
        calendar.appearance.titleFont = .pretendard(to: .regular, size: 18)
        calendar.appearance.selectionColor = UIColor(red: 67.0/255.0, green: 85.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        calendar.appearance.todayColor = .white
        calendar.appearance.titleTodayColor = .black
        
        // 일요일 라벨의 textColor를 red로 설정
        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        calendar.placeholderType = .none
        return calendar
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.title = "예약하기"
        
        //        setupSelectDateCalendar()
        setAction()
        configureSubviews()
        makeConstraints()
        updateWeekdayLabels()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(manualLabel)
        contentsView.addSubview(selectDateLabel)
        contentsView.addSubview(calendarView)
        contentsView.addSubview(prevButton)
        contentsView.addSubview(nextButton)
        
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.equalTo(2000)
        }
        manualLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentsView.snp.top).offset(34)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        selectDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(manualLabel.snp.bottom).offset(21)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        calendarView.snp.makeConstraints { (make) in
            make.top.equalTo(selectDateLabel.snp.bottom).offset(22)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(328)
        }
        prevButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.centerX.equalTo(calendarView.calendarHeaderView.snp.centerX).multipliedBy(0.6)
        }
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.centerX.equalTo(calendarView.calendarHeaderView.snp.centerX).multipliedBy(1.4)
        }
        
    }
    // MARK: - Action
    private func setAction() {
        [prevButton, nextButton].forEach {
            ($0 as AnyObject).addTarget(self, action: #selector(moveMonthButtonDidTap(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func moveMonthButtonDidTap(sender: UIButton) {
        moveMonth(next: sender == nextButton)
    }
    
    // 달 이동 로직
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        self.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.currentPage)!
        calendarView.setCurrentPage(self.currentPage, animated: true)
    }
    
    // MARK: - Methods
    
    //MARK: -Helpers
    private func updateWeekdayLabels() {
        let weekdayLabels = calendarView.calendarWeekdayView.weekdayLabels
        let customWeekdays = ["M", "T", "W", "T", "F", "S", "S"]
        
        for (index, label) in weekdayLabels.enumerated() {
            label.text = customWeekdays[index]
        }
    }
}


// MARK: - FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
extension ModelReservationDetailViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        let today = Date()
        
        if date < today {
            return .gray400
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sun" {
            return UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat" {
            return UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        } else {
            return .black
        }
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Date()
        return date >= today
    }
}
