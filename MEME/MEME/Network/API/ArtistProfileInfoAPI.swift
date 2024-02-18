//
//  ArtistProfileInfoAPI.swift
//  MEME
//
//  Created by 임아영 on 2/19/24.
//

import Foundation

import Moya

enum ArtistProfileInfoAPI {
    case getArtistProfileInfo(userId: Int)
}

extension ArtistProfileInfoAPI: MemeAPI {
    var domain: MemeDomain {
        return .mypage
    }
    
    var urlPath: String {
        switch self {
        case .getArtistProfileInfo(let userId):
            return "/profile/artist/\(userId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getArtistProfileInfo:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArtistProfileInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getArtistProfileInfo:
            return .requestPlain
        }
    }
}
