//
//  ModelData.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import Alamofire
import UIKit

class ModelUserDataManager {
    // MARK: 유저 프로필 조회 API
    func getUserProfil(_ viewController: ModelReservationViewController, _ userID: Int = 2) {
        // API 명세서 맞게 내용 수정하기
        AF.request("https://~~~~~~~~~\(userID)", method: .get, parameters: nil).validate().responseDecodable (of: ModelUserModel.self) {response in
            switch response.result {
            case .success(let result):
                print("성공")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
