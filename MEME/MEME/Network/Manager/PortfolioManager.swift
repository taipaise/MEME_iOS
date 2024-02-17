//
//  ReservationManager.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

final class ReservationManager {
    typealias API = ReservationAPI
    
    static let shared = ReservationManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func postReservation(
        modelId: Int,
        portfolioId: Int,
        date: String,
        time: ReservationTimes,
        dayOfWeek: DayOfWeek,
        location: String,
        completion: @escaping (Result<Response, MoyaError>) -> Void
    ) {
        provider.request(api: .postReservation(
            modelId: modelId,
            portfolioId: portfolioId,
            date: date,
            time: time,
            dayOfWeek: dayOfWeek,
            location: location
        )) { result in
            completion(result)
        }
    }
}
