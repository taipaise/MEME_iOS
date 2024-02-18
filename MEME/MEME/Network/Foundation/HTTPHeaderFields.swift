//
//  HTTPHeaderFields.swift
//  MEME
//
//  Created by 이동현 on 1/30/24.
//

import Foundation

enum HTTPHeaderFieldsKey {
    static let contentType = "Content-Type"
    static let authorization = "Authorization"
}

enum HTTPHeaderFieldsValue {
    static let html = "application/x-www-form-urlencoded"
    static let json = "application/json"
    static var accessToken: String { "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtZW1lX3VtYyIsImlhdCI6MTcwODIzNzgzOSwiZXhwIjoxODgxMDM3ODM5LCJzdWIiOiJhY2Nlc3MtdG9rZW4iLCJ1c2VybmFtZSI6IuyehOyerOyYgSIsInJvbGUiOiJST0xFX0FSVElTVCJ9.TnRBD5tiiOE9VgOGXx1gKsbuUKdS6QTRoOlm46M8fiBKRyneF-yjqOY17ZX74EjBgXKklf16rTuE7Q2pwD8TOg" }
}

enum HTTPHeaderFields {
    case plain
    case html
    case hasAccessToken
}
