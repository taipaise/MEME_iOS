//
//  NotificationViewModel.swift
//  MEME
//
//  Created by 이동현 on 7/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NotificationViewModel: ViewModel {
    enum CellModelsState {
        case fetchAll
        case readNotification
        case none
    }
    
    struct Input {
        let readCell: Observable<IndexPath>
        let refresh: Observable<Void>
    }
    
    struct Output {
        let cellModelsUpdatedType: Observable<CellModelsState>
    }
    
    private(set) var cellModels: [NotificationCellModel] = []
    private var cellModelsUpdateType = BehaviorRelay<CellModelsState>(value: .fetchAll)
    private var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.readCell
            .withUnretained(self)
            .subscribe { (self, indexPath) in
                self.readNotification(indexPath)
            }
            .disposed(by: disposeBag)
        
        input.refresh
            .withUnretained(self)
            .subscribe { (self, _) in
                self.referesh()
            }
            .disposed(by: disposeBag)
        
        return .init(cellModelsUpdatedType: cellModelsUpdateType.asObservable())
    }
    
    init() {
        makeDummies()
    }
}

extension NotificationViewModel {
    private func readNotification(_ indexPath: IndexPath) {
        guard cellModels[indexPath.row].isRead == false else { return }
        
        cellModels[indexPath.row].isRead = true
        cellModelsUpdateType.accept(.readNotification)
    }
    
    private func referesh() {
        makeDummies()
        cellModelsUpdateType.accept(.fetchAll)
    }
}


// MARK: - dummy
extension NotificationViewModel {
    private func makeDummies() {
        let dummies: [NotificationCellModel] = [
            .init(title: "1번째 알림", content: "치즈마시쩡님, 메이크업 필요하지 않으세요?\n지금 나에게 딱 맞는 메이크업을 예약해보세요!", type: .general, isRead: false),
            .init(title: "2번째 알림", content: "치즈마시쩡님, 메이크업 필요하지 않으세요?\n지금 나에게 딱 맞는 메이크업을 예약해보세요!", type: .general, isRead: false),
            .init(title: "3번째 알림", content: "치즈마시쩡님, 메이크업 필요하지 않으세요?\n지금 나에게 딱 맞는 메이크업을 예약해보세요!", type: .general, isRead: false),
            .init(title: "4번째 알림", content: "치즈마시쩡님, 메이크업 필요하지 않으세요?\n지금 나에게 딱 맞는 메이크업을 예약해보세요!", type: .general, isRead: false),
            .init(title: "5번째 알림", content: "치즈마시쩡님, 메이크업 필요하지 않으세요?\n지금 나에게 딱 맞는 메이크업을 예약해보세요!", type: .general, isRead: true),
            .init(title: "6번째 알림", content: "치즈마시쩡님, 메이크업 필요하지 않으세요?\n지금 나에게 딱 맞는 메이크업을 예약해보세요!", type: .general, isRead: true),
            .init(title: "7번째 알림", content: "치즈마시쩡님, 메이크업 필요하지 않으세요?\n지금 나에게 딱 맞는 메이크업을 예약해보세요!", type: .general, isRead: true),
            .init(title: "8번째 알림", content: "치즈마시쩡님, 메이크업 필요하지 않으세요?\n지금 나에게 딱 맞는 메이크업을 예약해보세요!", type: .general, isRead: true),
        ]
        
        cellModels = dummies
    }
}
