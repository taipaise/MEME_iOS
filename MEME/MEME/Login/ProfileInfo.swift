//
//  ProfileInfo.swift
//  MEME
//
//  Created by 이동현 on 2/18/24.
//

import Foundation

struct ProfileInfo {
    var id_token: String
    var provider: SocialProvider
    var profileImg: String
    var username: String
    var nickname: String
    var gender: Gender?
    var skinType: SkinType?
    var personalColor: PersonalColor?
}
