//
//  SearchAPIInput.swift
//  MEME
//
//  Created by 정민지 on 2/3/24.
//

import Foundation

struct SearchAllAPIInput {
    var page: Int?
    var sort: String?
}

struct SearchArtistAPIInput {
    var artistId: Int64
    var page: Int?
    var sort: String?
}

struct SearchCategoryAPIInput {
    var category: CategoryType
    var page: Int?
    var sort: String?
}

enum CategoryType: String {
    case daily = "데일리 메이크업"
    case actor = "배우 메이크업"
    case interview = "면접 메이크업"
    case party = "파티/이벤트 메이크업"
    case wedding = "웨딩 메이크업"
    case special = "특수 메이크업"
    case studio = "스튜디오 메이크업"
    case etc = "기타(속눈썹, 퍼스널 컬러)"
}

struct SearchRecentAPIInput {
    var query: String?
    var page: Int?
    var sort: String?
}
