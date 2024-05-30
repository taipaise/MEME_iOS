import Foundation
import Moya

enum AvailableTimeAPI {
    case patchAvailableTime(userId: Int, availableTimeDtoList: [AvailableTimeDto])
}

extension AvailableTimeAPI: MemeAPI {
    var domain: MemeDomain {
        return .availabletime
    }
    
    var urlPath: String {
        switch self {
        case .patchAvailableTime:
            return ""
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .patchAvailableTime:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchAvailableTime:
            return .patch
        }
    }
    
    var task: Task {
         switch self {
         case .patchAvailableTime(let userId, let availableTimeDtoList):
             let parameters: [String: Any] = [
                 "userId": userId,
                 "availableTimeDtoList": availableTimeDtoList.map { dto in
                     [
                         "date": dto.date,
                         "dayOfWeek": dto.dayOfWeek,
                         "times": dto.times
                     ]
                 }
             ]
             
             return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
         }
     }
 }
