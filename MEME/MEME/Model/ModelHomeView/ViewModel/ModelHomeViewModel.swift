//
//  ModelHomeViewModel.swift
//  MEME
//
//  Created by 정민지 on 4/3/24.
//

import RxSwift
import Foundation

class ModelHomeViewModel {
    let disposeBag = DisposeBag()
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
    func transform(input: Input) -> Output {
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

//MARK: - API호출 안될때 더미데이터
//class ModelHomeViewModel {
//    let disposeBag = DisposeBag()
//    private let reservationManager = ReservationManager.shared
//
//    struct Input {
//        let modelReservationsTrigger: Observable<Int>
//        let getRecommendArtistByReviewTrigger: Observable<Void>
//        let getRecommendArtistByRecentTrigger: Observable<Void>
//    }
//
//    struct Output {
//        let modelReservations: Observable<[ReservationData]>
//        let recommendArtistByReview: Observable<[Portfolio]>
//        let recommendArtistByRecent: Observable<[Portfolio]>
//    }
//
//    func transform(input: Input) -> Output {
//        // API 호출 대신 더미 데이터 생성 및 반환
//        let modelReservations = Observable.just(createDummyReservations())
//        let recommendArtistByReview = Observable.just(createDummyReviewPortfolios())
//        let recommendArtistByRecent = Observable.just(createDummyRecentPortfolios())
//
//        return Output(
//            modelReservations: modelReservations,
//            recommendArtistByReview: recommendArtistByReview,
//            recommendArtistByRecent: recommendArtistByRecent
//        )
//    }
//
//    // 더미 예약 데이터 생성 함수
//    private func createDummyReservations() -> [ReservationData] {
//        return [
//            ReservationData(reservationId: 3, portfolioId: 101, modelNickName: "Model A", artistNickName: "Artist X", makeupName: "Makeup 1", price: 100, reservationDate: "2023-10-01", reservationDayOfWeekAndTime: ["Monday": "10:00 AM"], shopLocation: "Location 1", status: "Confirmed"),
//            ReservationData(reservationId: 4, portfolioId: 101, modelNickName: "Model A", artistNickName: "Artist X", makeupName: "Makeup 2", price: 100, reservationDate: "2023-10-01", reservationDayOfWeekAndTime: ["Monday": "10:00 AM"], shopLocation: "Location 1", status: "Confirmed"),
//            ReservationData(reservationId: 5, portfolioId: 101, modelNickName: "Model A", artistNickName: "Artist X", makeupName: "Makeup 3", price: 100, reservationDate: "2023-10-01", reservationDayOfWeekAndTime: ["Monday": "10:00 AM"], shopLocation: "Location 1", status: "Confirmed")
//        ]
//    }
//
//    private func createDummyReviewPortfolios() -> [Portfolio] {
//        return [
//            Portfolio(portfolioId: 201, portfolioImg: "https://example.com/image.jpg", category: "Category 1", makeupName: "ㅎㅇㅎㅇ", artistName: "Artist Y", price: 200, makeupLocation: "Location X"),
//            Portfolio(portfolioId: 202, portfolioImg: "https://example.com/image.jpg", category: "Category 1", makeupName: "ㄱㄱ", artistName: "Artist Y", price: 200, makeupLocation: "Location X"),
//            Portfolio(portfolioId: 203, portfolioImg: "https://example.com/image.jpg", category: "Category 1", makeupName: "222", artistName: "Artist Y", price: 200, makeupLocation: "Location X"),
//            Portfolio(portfolioId: 204, portfolioImg: "https://example.com/image.jpg", category: "Category 1", makeupName: "3333", artistName: "Artist Y", price: 200, makeupLocation: "Location X"),
//            Portfolio(portfolioId: 205, portfolioImg: "https://example.com/image.jpg", category: "Category 1", makeupName: "4444ㅇ", artistName: "Artist Y", price: 200, makeupLocation: "Location X"),
//        ]
//    }
//
//    private func createDummyRecentPortfolios() -> [Portfolio] {
//        return [
//            Portfolio(portfolioId: 206, portfolioImg: "https://example.com/image.jpg", category: "Category 1", makeupName: "Makeup X", artistName: "Artist Y", price: 200, makeupLocation: "Location X")
//        ]
//    }
//}
