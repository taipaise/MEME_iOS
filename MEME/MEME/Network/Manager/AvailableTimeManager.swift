import Foundation
import Moya

final class AvailableTimeManager {
    typealias API = AvailableTimeAPI
    
    static let shared = AvailableTimeManager()
    let provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func patchAvailableTime(
        userId: Int,
        availableTimeDtoList: [AvailableTimeDto],
        completion: @escaping (Result<AvailableTimeDto, MoyaError>) -> Void
    ) {
        provider.request(.patchAvailableTime(userId: userId, availableTimeDtoList: availableTimeDtoList)) { result in
            switch result {
            case let .success(response):
                do {
                    let dto = try response.map(AvailableTimeDto.self)
                    completion(.success(dto))
                } catch {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
