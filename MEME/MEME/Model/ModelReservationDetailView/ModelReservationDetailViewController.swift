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
    // 예시 데이터 -> 추후 API 호출해서 데이터 받아오는 것으로 수정 필요
    private let availableTimes = ["10:30", "11:00","12:00", "12:30","13:00", "13:30","14:00", "14:30","15:00", "15:30","16:00", "16:30","17:00", "17:30","18:00", "18:30","19:00", "19:30", "20:00"]
    // MARK: - Properties
    private var selectedDate: Date?
    private var selectedTime: String?
    
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
    
    lazy var currentPage = calendarView.currentPage
    private let prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private var underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
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
        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        calendar.placeholderType = .none
        return calendar
    }()
    
    private var selectTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 가능 시간을 입력해주세요."
        label.textColor = .black
        label.font = .pretendard(to: .medium, size: 14)
        
        return label
    }()
    private var selectedTimeButton: UIButton?
    private var morningLabel: UILabel = {
        let label = UILabel()
        label.text = "오전"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private let morningVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    private let morningStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    private var afternoonLabel: UILabel = {
        let label = UILabel()
        label.text = "오후"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private let afternoonVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    private let afternoonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    private let reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBold
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "예약하기"
        
        updateNextButtonState()
        setAction()
        configureSubviews()
        makeConstraints()
        updateWeekdayLabels()
        setupTimeSelectionButtons()
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
        contentsView.addSubview(underLineView)
        contentsView.addSubview(selectTimeLabel)
        contentsView.addSubview(morningLabel)
        contentsView.addSubview(morningVerticalStackView)
        contentsView.addSubview(afternoonLabel)
        contentsView.addSubview(afternoonVerticalStackView)
        view.addSubview(reservationButton)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
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
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.calendarWeekdayView.snp.bottom).offset(7)
            make.leading.equalTo(calendarView.calendarWeekdayView.snp.leading)
            make.trailing.equalTo(calendarView.calendarWeekdayView.snp.trailing)
            make.height.equalTo(1)
        }
        selectTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(calendarView.snp.bottom).offset(33)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        morningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(selectTimeLabel.snp.bottom).offset(20)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        morningVerticalStackView.snp.makeConstraints { (make) in
            make.top.equalTo(morningLabel.snp.bottom).offset(13)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        afternoonLabel.snp.makeConstraints { (make) in
            make.top.equalTo(morningVerticalStackView.snp.bottom).offset(32)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        afternoonVerticalStackView.snp.makeConstraints { (make) in
            make.top.equalTo(afternoonLabel.snp.bottom).offset(13)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.bottom.equalTo(contentsView.snp.bottom).offset(-150)
        }
        reservationButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(50)
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
    
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        self.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.currentPage)!
        calendarView.setCurrentPage(self.currentPage, animated: true)
    }
    @objc private func nextTapped() {
        guard let selectedDate = selectedDate else { return }
        guard let selectedTime = selectedTime else { return }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        let formattedDate = formatter.string(from: selectedDate)
        
        let alert = UIAlertController(title: "", message: "\(formattedDate) \(selectedTime)시에 예약하시겠습니까?\n클릭하면 예약이 확정됩니다.", preferredStyle: .alert)
        let messageAttributes = [NSAttributedString.Key.font: UIFont.pretendard(to: .medium, size: 14), NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let noAction = UIAlertAction(title: "아니요", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let yesAction = UIAlertAction(title: "예", style: .default) { _ in
            let reservationsVC = ModelReservationLastViewController()
            self.navigationController?.pushViewController(reservationsVC, animated: true)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
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
    private func maxNumberOfButtonsPerRow() -> Int {
        let viewWidth = self.view.bounds.width
        let buttonWidth: CGFloat = 69
        let buttonSpacing: CGFloat = 8
        let sidePadding: CGFloat = 24 * 2
        let availableWidth = viewWidth - sidePadding
        let maxButtons = Int(availableWidth / (buttonWidth + buttonSpacing))
        
        return maxButtons
    }
    
    private func setupTimeSelectionButtons() {
        var currentMorningStackView = createNewHorizontalStackView()
        morningVerticalStackView.addArrangedSubview(currentMorningStackView)
        
        var currentAfternoonStackView = createNewHorizontalStackView()
        afternoonVerticalStackView.addArrangedSubview(currentAfternoonStackView)
        
        for time in availableTimes {
            let button = createButton(withTime: time)
            let hour = Int(time.split(separator: ":")[0])!
            
            if hour < 12 {
                if currentMorningStackView.arrangedSubviews.count >= maxNumberOfButtonsPerRow() {
                    currentMorningStackView = createNewHorizontalStackView()
                    morningVerticalStackView.addArrangedSubview(currentMorningStackView)
                }
                currentMorningStackView.addArrangedSubview(button)
            } else {
                if currentAfternoonStackView.arrangedSubviews.count >= maxNumberOfButtonsPerRow() {
                    currentAfternoonStackView = createNewHorizontalStackView()
                    afternoonVerticalStackView.addArrangedSubview(currentAfternoonStackView)
                }
                currentAfternoonStackView.addArrangedSubview(button)
            }
        }
        fillRemainingSpaceInLastStackView(currentMorningStackView)
        fillRemainingSpaceInLastStackView(currentAfternoonStackView)
    }
    private func fillRemainingSpaceInLastStackView(_ stackView: UIStackView) {
        let numberOfButtons = stackView.arrangedSubviews.count
        let maxButtonsPerRow = maxNumberOfButtonsPerRow()
        
        if numberOfButtons < maxButtonsPerRow {
            let numberOfEmptySpaces = maxButtonsPerRow - numberOfButtons
            for _ in 0..<numberOfEmptySpaces {
                let emptySpaceView = UIView()
                emptySpaceView.widthAnchor.constraint(equalToConstant: 69).isActive = true
                stackView.addArrangedSubview(emptySpaceView)
            }
        }
    }

    private func createNewVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private func createNewHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private func createButton(withTime time: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(time, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray400.cgColor
        button.widthAnchor.constraint(equalToConstant: 69).isActive = true
        
        return button
    }
    @objc private func timeButtonTapped(_ sender: UIButton) {
        selectedTimeButton?.layer.borderColor = UIColor.gray400.cgColor
        selectedTimeButton?.backgroundColor = .white
        
        sender.layer.borderColor = UIColor.mainBold.cgColor
        sender.backgroundColor = .mainBold
        selectedTimeButton = sender
        
        // 선택된 시간 저장 -> 추후 api post 요청할때 전송
        selectedTime = sender.title(for: .normal)
        updateNextButtonState()
    }
    // 날짜가 선택될 때 호출되는 메서드 (FSCalendarDelegate 메서드 내에서 호출)
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        updateNextButtonState()
    }
    
    //모두 선택해야 다음 버튼 활성화
    private func updateNextButtonState() {
        reservationButton.isEnabled = selectedDate != nil && selectedTime != nil
        reservationButton.backgroundColor = reservationButton.isEnabled ? .mainBold : .gray300
    }
}
    
    
// MARK: - FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
extension ModelReservationDetailViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
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
