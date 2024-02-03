import Foundation
import Moya

enum BusinessIDVerificationAPI {
    case verifyId(id: String, name: String, date: String)
}

extension BusinessIDVerificationAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.odcloud.kr/api/nts-businessman/v1") else {
            fatalError("baseURL 가져오기 실패")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .verifyId:
            return "/validate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .verifyId:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .verifyId(id: let id, name: let name, date: let date):
            let jsonData: [String: Any] = [
                "b_no": "\(id)",
                "start_dt": "\(date)",
                "p_nm": "\(name)",
                "p_nm2": "",
                "b_nm": "",
                "corp_no": "",
                "b_sector": "",
                "b_type": "",
                "b_adr": ""
            ]
            let jsonParameters: [String: Any] = ["businesses": [jsonData]]
            let serviceKey = "bv8Vhy1/BjI0w0pPuVmyzn2Kmfjs0BEjBdwZmQwTtPUzpaN2dxbUzA5jedQpfL2k52LbO2EFQyXpFffzOG65cw=="
            let queryStringParameters: [String: Any] = ["serviceKey": serviceKey]
            
            return .requestCompositeParameters(
                bodyParameters: jsonParameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: queryStringParameters
            )
        }
    }
    
    var headers: [String : String]? {
        return [HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.json]
    }
}
