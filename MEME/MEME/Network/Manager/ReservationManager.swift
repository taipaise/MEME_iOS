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
    
    // MARK: 아티스트 예약 가능 장소 조회 API
    func getPossibleLocation(aristId: Int, completion: @escaping (Result<PossibleLocationsDTO, MoyaError>) -> Void) {
        provider.request(api: .getPossibleLocation(aristId: aristId)) { result in
            switch result {
            case .success(let response):
                do {
                    let locations = try JSONDecoder().decode(PossibleLocationsDTO.self, from: response.data)
                    completion(.success(locations))
                    print("성공: \(locations)")
                } catch let error {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: 모델 예약 조회 API
    func getModelReservation(
        modelId: Int,
        completion: @escaping (Result<ReservationDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getModelReservation(modelId: modelId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(ReservationDTO.self, from: response.data)
                    completion(.success(decodedData))
                } catch let error {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
