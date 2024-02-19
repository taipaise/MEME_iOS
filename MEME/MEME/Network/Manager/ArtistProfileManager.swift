//
//  ArtistProfileManager.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation
import Moya

final class ArtistProfileManager {
    typealias API = ArtistProfileAPI
    
    static let shared = ArtistProfileManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func patchProfile(artistId: Int, profileImg: String?, nickname: String?, gender: Gender?, introduction: String?, workExperience: WorkExperience?, region: [Region]?, specialization: [Category]?, makeupLocation: MakeupLocation?, shopLocation: String?, availableDayOfWeek: [DayOfWeek: Times]?, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(api: .patchProfile(artistId: artistId, profileImg: profileImg, nickname: nickname, gender: gender, introduction: introduction, workExperience: workExperience, region: region, specialization: specialization, makeupLocation: makeupLocation, shopLocation: shopLocation, availableDayOfWeek: availableDayOfWeek)) { result in
        }
    }
}
