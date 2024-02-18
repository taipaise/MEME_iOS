//
//  ProfileInfoBuilder.swift
//  MEME
//
//  Created by 이동현 on 2/18/24.
//

import Foundation

final class ProfileInfoBuilder {
    private var idToken = ""
    private var provider = ""
    private var profileImg = ""
    private var username = ""
    private var nickname = ""
    private var gender: String?
    var skinType: String?
    var personalColor: String?
    
    func idToken(_ idToken: String) -> ProfileInfoBuilder {
        self.idToken = idToken
        return self
    }
    
    func provider(_ provider: String) -> ProfileInfoBuilder {
        self.provider = provider
        return self
    }
    
    func profileImg(_ profileImg: String) -> ProfileInfoBuilder {
        self.profileImg = profileImg
        return self
    }
    
    func username(_ username: String) -> ProfileInfoBuilder {
        self.username = username
        return self
    }
    
    func nickname(_ nickname: String) -> ProfileInfoBuilder {
        self.nickname = nickname
        return self
    }
    
    func gender(_ gender: String) -> ProfileInfoBuilder {
        self.gender = gender
        return self
    }
    
    
    func skinType(_ skinType: String) -> ProfileInfoBuilder {
        self.skinType = skinType
        return self
    }
    
    func personalColor(_ personalColor: String) -> ProfileInfoBuilder {
        self.personalColor = personalColor
        return self
    }
    
    func build() -> ProfileInfo {
        return ProfileInfo(
            id_token: idToken,
            provider: provider,
            profileImg: profileImg,
            username: username,
            nickname: nickname,
            gender: gender,
            skinType: skinType,
            personalColor: personalColor
        )
    }
}
