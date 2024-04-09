//
//  ModelHomeViewModel.swift
//  MEME
//
//  Created by 정민지 on 4/3/24.
//

import RxSwift
import Foundation

class ModelHomeViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let reservationManager = ReservationManager.shared
    
    //MARK: - Input
    struct Input {
            let modelReservationsTrigger: Observable<Int>
            let getRecommendArtistByReviewTrigger: Observable<Void>
            let getRecommendArtistByRecentTrigger: Observable<Void>
        }
        
        struct Output {
            let modelReservations: Observable<[ReservationData]>
            let recommendArtistByReview: Observable<[Portfolio]>
            let recommendArtistByRecent: Observable<[Portfolio]>
        }
    
    //MARK: - transform
    func transform(_ input: Input) -> Output {
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
            recommendArtistByRecent: recommendArtistByRecent
        )
    }
    
    //MARK: - API
    private func fetchModelReservations(modelId: Int) -> Observable<[ReservationData]> {
        return Observable.create { observer in
            self.reservationManager.getModelReservation(modelId: modelId) { result in
                switch result {
                case .success(let reservationDTO):
                    let filteredData = reservationDTO.data?.filter { reservationData in
                        if let date = self.dateFromString(reservationData.reservationDate),
                           self.isToday(date),
                           reservationData.status == "EXPECTED" {
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
