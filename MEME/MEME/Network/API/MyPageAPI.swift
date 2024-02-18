//
//  MyPageAPI.swift
//  MEME
//
//  Created by 임아영 on 2/9/24.

//

import Foundation
import Moya

enum MyPageAPI {
    case getMyPageProfile(userId: Int)
    case getMyPage(userId: Int)
    case patchProfile(
        modelId: Int,
        profileImg: String,
        nickName: String,
        gender: Gender,
        skinType: SkinType,
        personalColor: PersonalColor
    )
    case getFavoriteArtist(modelId: Int, page: Int?)
    case getFavoritePortfolio(
        modelId: Int,
        portfolioId: Int
    )
    case postFavoriteArtist(
        modelId: Int,
        artistId: Int
    )
    case postFavoritePortfolio(
        modelId: Int,
        portfolioId: Int
    )
    case deleteFavoriteArtist(
        modelId: Int,
        artistId: Int
    )
    case deleteFavoritePortfolio(
        modelId: Int,
        portfolioId: Int
    )
    case patchModelProfile(
        userId: Int,
        profileImg: String,
        nickname: String,
        gender: Gender,
        skinYype: SkinType,
        personalColor: PersonalColor
    )
    case patchArtistProfile(
        userId: Int,
        profileImg: String,
        nickname: String,
        gender: Gender,
        introduction: String,
        workExperience: WorkExperience,
        region: [Region],
        specialization: [SearchCategory],
        makeupLocation: MakeUpLocation,
        shopLocation: String,
        availableDayOfWeek: [DayOfWeek: ReservationTimes]
    )
    case getProfileManagementData(userId: Int)
}

extension MyPageAPI: MemeAPI {

  var domain: MemeDomain {
        return .mypage
    }
    
  var urlPath: String {
        switch self {
        case .getMyPageProfile(let userId):
            return "/profile/\(userId)"
        case .getMyPage(userId: let id):
            return "/profile/\(id)"
        case .patchProfile:
            return "/profile/model"
        case .getFavoriteArtist(modelId: let id, _):
            return "/\(id)/favorite/artist"
        case .getFavoritePortfolio(modelId: let id, _):
            return "/\(id)/favorite/portfolio"
        case .postFavoriteArtist:
            return "/favorite/artist"
        case .postFavoritePortfolio:
            return "/favorite/portfolio"
        case .deleteFavoriteArtist:
            return "/favorite/artist"
        case .deleteFavoritePortfolio:
            return "/favorite/portfolio"
        case .patchModelProfile:
            return "/profile/model"
        case  .patchArtistProfile:
            return "/profile/artist"
        case .getProfileManagementData(userId: let id):
            return "/profile/artist/\(id)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getMyPageProfile, .getMyPage, .patchProfile, .getFavoriteArtist, .getFavoritePortfolio, .postFavoriteArtist, .postFavoritePortfolio, .deleteFavoriteArtist, .deleteFavoritePortfolio, .patchModelProfile, .patchArtistProfile, .getProfileManagementData:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchProfile:
            return .patch
        case .getMyPageProfile, .getMyPage, .getFavoriteArtist, .getFavoritePortfolio, .getProfileManagementData:
            return .get
        case .postFavoriteArtist, .postFavoritePortfolio:
            return .post
        case .patchModelProfile, .patchArtistProfile:
            return .patch
        case .deleteFavoriteArtist, .deleteFavoritePortfolio:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getMyPageProfile:
            return .requestPlain
        case .patchProfile(
            modelId: let modelId,
            profileImg: let profileImg,
            nickName: let nickName,
            gender: let gender,
            skinType: let skinType,
            personalColor: let personalColor):
            let parameters: [String: Any] = [
                "model_id": modelId,
                "profile_img": profileImg,
                "nickName": nickName,
                "gender": gender,
                "skin_type": skinType,
                "personal_color": personalColor
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getMyPage, .getFavoritePortfolio:
            return .requestPlain
        case .getFavoriteArtist(_, let page):
            var params: [String: Any] = [:]
            if let page = page {
                params["page"] = page
                
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .postFavoriteArtist(modelId: let modelId, artistId: let artistId):
            let parameters = [
                "modelId": modelId,
                "artistId": artistId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .postFavoritePortfolio(modelId: let modelId, portfolioId: let portfolioId):
            let parameters = [
                "modelId": modelId,
                "portfolioId": portfolioId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .deleteFavoriteArtist(modelId: let modelId, artistId: let artistId):
            let parameters = [
                "modelId": modelId,
                "artistId": artistId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .deleteFavoritePortfolio(modelId: let modelId, portfolioId: let portfolioId):
            let parameters = [
                "modelId": modelId,
                "portfolioId": portfolioId
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .patchModelProfile(
            userId: let userId,
            profileImg: let profileImg,
            nickname: let nickname,
            gender: let gender,
            skinYype: let skinYype,
            personalColor: let personalColor):
            var parameters: [String: Any] = [
                "userId": userId,
                "profileImg": profileImg,
                "nickname": nickname,
                "gender": gender,
                "skinYype": skinYype,
                "personalColor": personalColor
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .patchArtistProfile(
            userId: let userId,
            profileImg: let profileImg,
            nickname: let nickname,
            gender: let gender,
            introduction: let introduction,
            workExperience: let workExperience,
            region: let region,
            specialization: let specialization,
            makeupLocation: let makeupLocation,
            shopLocation: let shopLocation,
            availableDayOfWeek: let availableDayOfWeek):
            var parameters: [String: Any] = [
                "userId": userId,
                "profileImg": profileImg,
                "nickname": nickname,
                "gender": gender,
                "introduction": introduction,
                "workExperience": workExperience,
                "region": region,
                "specialization": specialization,
                "makeupLocation": makeupLocation,
                "shopLocation": shopLocation,
                "availableDayOfWeek": availableDayOfWeek
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .getProfileManagementData(userId: let userId):
            var parameters: [String: Any] = ["userId": userId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
