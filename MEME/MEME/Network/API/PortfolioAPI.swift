//

//  PortfolioAPI.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.
//
import Foundation
import Moya

enum PortfolioAPI {
    case createPortfolio(
            artistId : Int,
            category : PortfolioCategories,
            makeup_name : String,
            price : Int,
            info : String,
            portfolio_img_src : [String]
            
    )
    case getAllPortfolio(
        artistId : Int,
        page : Int
    )
    case editPortfolio(
        artistId : Int,
        portfolioId : Int,
        category : PortfolioCategories,
        makeup_name : String,
        price : Int,
        info : String,
        isBlock: Bool,
        portfolio_img_src : [ImageData]
    )
    case getPortfolioDetail(
        userId: Int,
        portfolioId: Int
    )
    case getRecommendArtistByReview
    case getRecommendArtistByRecent
}

extension PortfolioAPI: MemeAPI {
    var domain: MemeDomain {
        return .portfolio
    }
    
    var urlPath: String {
        switch self {
        case .createPortfolio:
                    return ""
        case .getAllPortfolio(let artistId, let page):
            return "/\(artistId)"
        case .editPortfolio:
            return ""
        case .getPortfolioDetail(userId: let userId, portfolioId: let portfolioId):
            return "/details/\(userId)/\(portfolioId)"
        case .getRecommendArtistByReview:
            return "/recommend/review"
        case .getRecommendArtistByRecent:
            return "/recommend/recent"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .createPortfolio, .getAllPortfolio, .editPortfolio,.getPortfolioDetail, .getRecommendArtistByReview, .getRecommendArtistByRecent:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createPortfolio:
            return .post
        case .getAllPortfolio:
            return .get
        case .editPortfolio:
            return .patch
        case .getPortfolioDetail, .getRecommendArtistByReview, .getRecommendArtistByRecent:
            return .get

        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createPortfolio(
            artistId: let artistId,
            category: let category,
            makeup_name: let makeup_name,
            price: let price,
            info: let info,
            portfolio_img_src: let portfolio_img_src
        ):
            let parameters: [String: Any] = [
                "artistId": artistId,
                "category": category.rawValue,
                "makeupName": makeup_name,
                "price": price,
                "info": info,
                "portfolioImgSrc": portfolio_img_src
            ]
          
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        
        case .getAllPortfolio(
            artistId: let artistId,
            page: let page
        ):
            let parameters: [String:Any] = [
                "page": page
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .editPortfolio(
            artistId: let artistId,
            portfolioId: let portfolioId,
            category: let category,
            makeup_name: let makeup_name,
            price: let price,
            info: let info,
            isBlock: let isBlock,
            portfolio_img_src: let portfolio_img_src
        ):
            let parameters: [String:Any] = [
                "artistId": artistId,
                "portfolioId": portfolioId,
                "category": category.rawValue,
                "makeupName": makeup_name,
                "price": price,
                "info": info,
                "isBlock": isBlock,
                "portfolioImgList": portfolio_img_src
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getPortfolioDetail(
            portfolioId: let portfolioId):
            var parameters: [String: Any] = ["portfolioId": portfolioId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getRecommendArtistByReview:
            return .requestPlain
        case .getRecommendArtistByRecent:
            return .requestPlain
        }
    }
}
