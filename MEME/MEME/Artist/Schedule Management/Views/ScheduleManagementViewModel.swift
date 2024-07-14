//
//  ScheduleManagementViewModel.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ScheduleManagementViewModel: ViewModel {
    enum TimeCellModelUpdateType {
        case initialization
        case changed
    }
    
    struct Input {
        let changeSegment: Observable<ScheduleSegmentType>
        let selectDayOfWeek: Observable<Int>
        let resetSelectedTime: Observable<Void>
        let toggleSelectedTime: Observable<IndexPath>
        let reqeustToSaveTimes: Observable<Void>
    }
    
    struct Output {
        let selectedSegment: Observable<ScheduleSegmentType>
        let selectedDayOfWeek: Observable<DayOfWeek>
        let cellModelUpdatedType: Observable<TimeCellModelUpdateType>
        let isSelectedCellEmpty: Observable<Bool>
    }
    
    private var selectedSegment = BehaviorRelay<ScheduleSegmentType>(value: .timeTable)
    private(set) var amCellModels: [ScheduleTimeTableCellModel] = []
    private(set) var pmCellModels: [ScheduleTimeTableCellModel] = []
    private var isSelectedCellModelEmpty = BehaviorRelay<Bool>(value: true)
    private var cellModelUpdated = BehaviorRelay<TimeCellModelUpdateType>(value: .initialization)
    private var selectedDayofWeek = BehaviorRelay<DayOfWeek>(value: .MON)
    private var selectedTimesOfWeek: [ReservationOfWeek] = []
    private var disposeBag = DisposeBag()
    
    init() {
        initCellModels()
    }
    
    
    func transform(_ input: Input) -> Output {
        input.changeSegment
            .withUnretained(self)
            .subscribe { (self, type) in
                self.selectedSegment.accept(type)
            }
            .disposed(by: disposeBag)
        
        input.resetSelectedTime
            .withUnretained(self)
            .subscribe { (self, _) in
                self.resetDayOfWeek()
            }
            .disposed(by: disposeBag)
        
        input.selectDayOfWeek
            .withUnretained(self)
            .subscribe { (self, dayOfWeekIndex) in
                self.changeDayOfWeek(dayOfWeekIndex: dayOfWeekIndex)
            }
            .disposed(by: disposeBag)
        
        input.toggleSelectedTime
            .withUnretained(self)
            .subscribe { (self, indexPath) in
                self.toggleSelectedTime(indexPath: indexPath)
            }
            .disposed(by: disposeBag)
    
        input.reqeustToSaveTimes
            .withUnretained(self)
            .subscribe { (self, indexPath) in
                self.requestSaveTimes()
            }
            .disposed(by: disposeBag)
        
        return .init(
            selectedSegment: selectedSegment.asObservable(),
            selectedDayOfWeek: selectedDayofWeek.asObservable(),
            cellModelUpdatedType: cellModelUpdated.asObservable(),
            isSelectedCellEmpty: isSelectedCellModelEmpty.asObservable()
        )
    }
}

// MARK: - handle segment
extension ScheduleManagementViewModel {
    private func toggleSegment(type: ScheduleSegmentType) {
        selectedSegment.accept(type)
    }
}

// MARK: - handle timeTable
extension ScheduleManagementViewModel {
    //서버에서 시간 가져오기
    private func fetchCellModels() {
        
    }
    
    //초기 cell 세팅(서버에 데이터 없는 경우)
    private func initCellModels() {
        selectedTimesOfWeek = DayOfWeek.allCases.map { .init(dayOfWeek: $0) }
        var timeCellModels: [ScheduleTimeTableCellModel]
        timeCellModels = ReservationTimes.allCases.map {
            let timeStrings = $0.rawValue.split(separator: ":")
            let hour = Int(timeStrings[0])!
            let min = Int(timeStrings[1])!
            let type: TimeType = hour < 12 ? .am : .pm
            
            return .init(
                type: type,
                time: $0,
                hour: hour,
                min: min
            )
        }
        
        amCellModels = timeCellModels.filter({ $0.type == .am })
        pmCellModels = timeCellModels.filter({ $0.type == .pm })
        cellModelUpdated.accept(.initialization)
    }
    
    //시간을 선택하는 경우
    private func toggleSelectedTime(indexPath: IndexPath) {
        let time: ReservationTimes
        let dayOfWeek = selectedDayofWeek.value.intVal
        let section = indexPath.section
        let row = indexPath.row
        
        if section == TimeType.am.rawValue {
            time = amCellModels[row].time
            amCellModels[row].selected.toggle()
        } else {
            time = pmCellModels[row].time
            pmCellModels[row].selected.toggle()
        }
        
        let isSelected = selectedTimesOfWeek[dayOfWeek].selectedTime.contains(time)
        if isSelected {
            selectedTimesOfWeek[dayOfWeek].selectedTime.remove(time)
        } else {
            selectedTimesOfWeek[dayOfWeek].selectedTime.insert(time)
        }
        let isSelectedCellModelEmpty = selectedTimesOfWeek[dayOfWeek].selectedTime.isEmpty
        self.isSelectedCellModelEmpty.accept(isSelectedCellModelEmpty)
        cellModelUpdated.accept(.changed)
        
    }
    
    //요일을 바꾸는 경우
    private func changeDayOfWeek(dayOfWeekIndex: Int) {
        let dayOfWeek = DayOfWeek.allCases[dayOfWeekIndex]
        let selectedTimes = selectedTimesOfWeek[dayOfWeekIndex]
        selectedDayofWeek.accept(dayOfWeek)
        
        for i in 0..<amCellModels.count {
            let time = amCellModels[i].time
            if selectedTimes.selectedTime.contains(time) {
                amCellModels[i].selected = true
            } else {
                amCellModels[i].selected = false
            }
        }
        
        for i in 0..<pmCellModels.count {
            let time = pmCellModels[i].time
            if selectedTimes.selectedTime.contains(time) {
                pmCellModels[i].selected = true
            } else {
                pmCellModels[i].selected = false
            }
        }
        let isSelectedCellModelEmpty = selectedTimes.selectedTime.isEmpty
        self.isSelectedCellModelEmpty.accept(isSelectedCellModelEmpty)
        cellModelUpdated.accept(.changed)
    }
    
    //없음을 선택하는 경우
    private func resetDayOfWeek() {
        let dayOfWeek = selectedDayofWeek.value.intVal
        selectedTimesOfWeek[dayOfWeek].selectedTime.removeAll()
        
        for i in 0..<amCellModels.count {
            amCellModels[i].selected = false
        }
        
        for i in 0..<pmCellModels.count {
            pmCellModels[i].selected = false
        }
        
        isSelectedCellModelEmpty.accept(true)
        cellModelUpdated.accept(.changed)
    }
}

extension ScheduleManagementViewModel {
    private func requestSaveTimes() {
        
    }
}
