//
//  ModelHomeViewModel.swift
//  MEME
//
//  Created by 정민지 on 4/3/24.
//

import RxSwift
import Foundation

final class ModelHomeViewModel: ViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let reservationManager = ReservationManager.shared
    
    //MARK: - Input
    
    struct Input {
        let modelReservationsTrigger: Observable<Int>
        let getRecommendArtistByReviewTrigger: Observable<Void>
        let getRecommendArtistByRecentTrigger: Observable<Void>
        let userNicknameTrigger: Observable<Void>
    }
    
    //MARK: - Output
    
    struct Output {
        let modelReservations: Observable<[ReservationData]>
        let recommendArtistByReview: Observable<[Portfolio]>
        let recommendArtistByRecent: Observable<[Portfolio]>
        let userNickname: Observable<String>
    }
    
    //MARK: - transform
    
    func transform(_ input: Input) -> Output {
        let userNickname = input.userNicknameTrigger
            .flatMapLatest { _ -> Observable<String> in
                if let nickname = KeyChainManager.read(forkey: .nickName), !nickname.isEmpty {
                    return Observable.just(nickname)
                } else {
                    return Observable<String>.create { observer in
                        self.fetchUserNicknameFromAPI { nickname in
                            observer.onNext(nickname)
                            observer.onCompleted()
                        }
                        return Disposables.create()
                    }
                }
            }
            .startWith("환영합니다!")
        
        let modelReservations = input.modelReservationsTrigger
            .flatMapLatest { modelId -> Observable<[ReservationData]> in
                return self.fetchModelReservations(modelId: modelId)
                    .catchAndReturn([])
            }
        
        let recommendArtistByReview = input.getRecommendArtistByReviewTrigger
            .flatMapLatest { _ in
                return self.fetchRecommendArtistByReview()
                    .catchAndReturn([])
            }
        
        let recommendArtistByRecent = input.getRecommendArtistByRecentTrigger
            .flatMapLatest { _ in
                return self.fetchRecommendArtistByRecent()
                    .catchAndReturn([])
            }
        
        return Output(
            modelReservations: modelReservations,
            recommendArtistByReview: recommendArtistByReview,
            recommendArtistByRecent: recommendArtistByRecent,
            userNickname: userNickname
        )
    }
}

//MARK: - API

extension ModelHomeViewModel {
    private func fetchModelReservations(modelId: Int) -> Observable<[ReservationData]> {
        return Observable.create { observer in
            self.reservationManager.getModelReservation(modelId: modelId) { result in
                switch result {
                case .success(let reservationDTO):
                    let filteredData = reservationDTO.data?.filter { reservationData in
                        if let date = self.dateFromString(reservationData.reservationDate),
                           self.isToday(date),
                           reservationData.status == ReservationState.EXPECTED.rawValue {
                            return true
                        }
                        return false
                    }
                    observer.onNext(filteredData ?? [])
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    private func fetchRecommendArtistByReview() -> Observable<[Portfolio]> {
        return Observable.create { observer in
            PortfolioManager.shared.getRecommendArtistByReview { result in
                switch result {
                case .success(let recommendResponse):
                    observer.onNext(recommendResponse.data )
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    private func fetchRecommendArtistByRecent() -> Observable<[Portfolio]> {
        return Observable.create { observer in
            PortfolioManager.shared.getRecommendArtistByRecent{ result in
                switch result {
                case .success(let recommendResponse):
                    observer.onNext(recommendResponse.data )
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    private func fetchUserNicknameFromAPI(completion: @escaping (String) -> Void) {
        MyPageManager.shared.getMyPageProfile(userId: KeyChainManager.loadMemberID()) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let nickname = response.data?.nickname
                    KeyChainManager.save(forKey: .nickName, value: nickname ?? "")
                    completion(nickname ?? "")
                case .failure(let error):
                    print("Error fetching profile: \(error)")
                    completion("환영합니다!")
                }
            }
        }
    }

    
    //MARK: - Method
    
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
    }
    
    private func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDateInToday(date)
    }
}
