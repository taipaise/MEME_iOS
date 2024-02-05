//
//  SearchModel.swift
//  MEME
//
//  Created by 정민지 on 2/3/24.
//

import Foundation

struct SearchModel: Decodable {
    var code: Int
    var result: String
    var message: String?
    //이거 데이터에 맞게 바꾸기...?
    var data: String?
}
