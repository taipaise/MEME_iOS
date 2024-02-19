//
//  ProfileAPI.swift
//  MEME
//
//  Created by 정민지 on 2/19/24.
//

import Foundation
import Moya

enum ProfileAPI {
    case getArtistProfile(
        userId: Int,
        artistId: Int
    )
}

extension ProfileAPI: MemeAPI {
    var domain: MemeDomain {
        return .profile
    }
    
    var urlPath: String {
        switch self {

        case .getArtistProfile(userId: let userId, artistId: let artistId):
            return "/\(userId)/\(artistId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getArtistProfile:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArtistProfile:
            return .get

        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getArtistProfile(
            userId: let userId,
            artistId: let artistId):
            var parameters: [String: Any] = ["userId": userId, "artistId": artistId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
