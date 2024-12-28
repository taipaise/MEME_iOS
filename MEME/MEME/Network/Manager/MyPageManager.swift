//
//  MyPageManager.swift
//  MEME
//
//  Created by 임아영 on 2/9/24.
//

import Foundation
import Moya

final class MyPageManager {
    typealias API = MyPageAPI
    
    static let shared = MyPageManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func getMyPageProfile(userId: Int, completion: @escaping (Result<MyPageResponse, MoyaError>) -> Void) {
        provider.request(api: .getMyPageProfile(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let myPageResponse = try JSONDecoder().decode(MyPageResponse.self, from: response.data)
                    completion(.success(myPageResponse))
                } catch {
                    completion(.failure(MoyaError.objectMapping(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    // MARK: -관심 아티스트 조회 API
    func getFavoriteArtists(
        modelId: Int,
        page: Int? = nil,
        completion: @escaping (Result<FavoriteArtistsDTO, MoyaError>) -> Void
    ) {
        var params: [String: Any] = [:]
        if let page = page {
            params["page"] = page
        }
        
        provider.request(api: .getFavoriteArtist(
            modelId: modelId,
            page: page
        )) { result in
            switch result {
            case .success(let response):
                do {
                    let artists = try JSONDecoder().decode(FavoriteArtistsDTO.self, from: response.data)
                    completion(.success(artists))
                } catch let error {
                    print("Error decoding favorite artists: \(error)")
                    completion(.failure(MoyaError.encodableMapping(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -관심 메이크업 추가 API
    func postFavoritePortfolio(
        modelId: Int,
        portfolioId: Int,
        completion: @escaping (Result<FavoriteDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .postFavoritePortfolio(modelId: modelId, portfolioId: portfolioId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let favoritePortfolio = try decoder.decode(FavoriteDTO.self, from: response.data)
                    completion(.success(favoritePortfolio))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    
    // MARK: -관심 메이크업 삭제 API
    func deleteFavoritePortfolio(
        modelId: Int,
        portfolioId: Int,
        completion: @escaping (Result<FavoriteDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .deleteFavoritePortfolio(modelId: modelId, portfolioId: portfolioId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let favoritePortfolio = try decoder.decode(FavoriteDTO.self, from: response.data)
                    completion(.success(favoritePortfolio))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -관심 아티스트 추가 API
    func postFavoriteArtist(
        modelId: Int,
        artistId: Int,
        completion: @escaping (Result<FavoriteDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .postFavoriteArtist(modelId: modelId, artistId: artistId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let favoritePortfolio = try decoder.decode(FavoriteDTO.self, from: response.data)
                    completion(.success(favoritePortfolio))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: -관심 아티스트 삭제 API
    func deleteFavoriteArtist(
        modelId: Int,
        artistId: Int,
        completion: @escaping (Result<FavoriteDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .deleteFavoriteArtist(modelId: modelId, artistId: artistId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let favoritePortfolio = try decoder.decode(FavoriteDTO.self, from: response.data)
                    completion(.success(favoritePortfolio))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    // MARK: -모델 프로필 관리 API
    func patchModelProfile(
        userId: Int,
        profileImg: String,
        nickname: String,
        gender: Gender,
        skinYype: SkinType,
        personalColor: PersonalColor,
        completion: @escaping (Result<PatchProfileDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .patchModelProfile(
            userId: userId,
            profileImg: profileImg,
            nickname: nickname,
            gender: gender,
            skinYype: skinYype,
            personalColor: personalColor
        )){ result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(PatchProfileDTO.self, from: response.data)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: -아티스트 프로필 관리 API
    func patchArtistProfile(
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
        availableDayOfWeek: [DayOfWeek: ReservationTimes],
        completion: @escaping (Result<PatchProfileDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .patchArtistProfile(
            userId: userId,
            profileImg: profileImg,
            nickname: nickname,
            gender: gender,
            introduction: introduction,
            workExperience: workExperience,
            region: region,
            specialization: specialization,
            makeupLocation: makeupLocation,
            shopLocation: shopLocation,
            availableDayOfWeek: availableDayOfWeek
        )){ result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(PatchProfileDTO.self, from: response.data)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -프로필 조회(관리 정보 불러오기) API
    func getProfileManagementData(userId: Int, completion: @escaping (Result<ProfileManagementDataDTO, MoyaError>) -> Void) {
        provider.request(api: .getProfileManagementData(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let gotPortfolio = try decoder.decode(ProfileManagementDataDTO.self, from: response.data)
                    completion(.success(gotPortfolio))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }    
}
