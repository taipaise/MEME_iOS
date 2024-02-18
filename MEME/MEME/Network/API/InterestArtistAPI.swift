//
//  InterestArtistAPI.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation

import Moya

enum InterestArtistAPI {
    case getInterestArtist(modelId: Int, artistId: Int, artistNickName: String, profileImg: String)
}

extension InterestArtistAPI: MemeAPI {
    var domain: MemeDomain {
        return .mypage
    }
    
    var urlPath: String {
        switch self {
        case .getInterestArtist(let modelId, _, _, _):
            return "/\(modelId)/favorite/artist"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getInterestArtist:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getInterestArtist:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getInterestArtist(_, let ID, let name, let image):
            return .requestParameters(parameters: ["artistID": ID, "artistNickName": name, "profileImg": image] , encoding: URLEncoding.queryString)
               }
    }
}
