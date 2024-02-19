//
//  ArtistProfileAPI.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation
import Moya

enum ArtistProfileAPI {
    case patchProfile(artistId: Int, profileImg: String?, nickname: String?, gender: Gender?, introduction: String?, workExperience: WorkExperience?, region: [Region]?, specialization: [Category]?, makeupLocation: MakeupLocation?, shopLocation: String?, availableDayOfWeek: [DayOfWeek: Times]?)
}

extension ArtistProfileAPI: MemeAPI {
    var domain: MemeDomain {
        return .profile
    }
    
    var urlPath: String {
        switch self {
        case .patchProfile:
            return "profile/artist"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .patchProfile:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchProfile:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .patchProfile(let artistId, let profileImg, let nickname, let gender, let introduction, let workExperience, let region, let specialization, let makeupLocation, let shopLocation, let availableDayOfWeek):
            var parameters: [String: Any] = ["artist_id": artistId]
            if let profileImg = profileImg { parameters["profile_img"] = profileImg }
            if let nickname = nickname { parameters["nickname"] = nickname }
            if let gender = gender { parameters["gender"] = gender.rawValue }
            if let introduction = introduction { parameters["introduction"] = introduction }
            if let workExperience = workExperience { parameters["work_experience"] = workExperience.rawValue }
            if let region = region { parameters["region"] = region.map { $0.rawValue } }
            if let specialization = specialization { parameters["specialization"] = specialization.map { $0.rawValue } }
            if let makeupLocation = makeupLocation { parameters["makeup_location"] = makeupLocation.rawValue }
            if let shopLocation = shopLocation { parameters["shop_location"] = shopLocation }
            if let availableDayOfWeek = availableDayOfWeek { parameters["available_day_of_week"] = availableDayOfWeek.mapValues { try? JSONEncoder().encode($0) } }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}

