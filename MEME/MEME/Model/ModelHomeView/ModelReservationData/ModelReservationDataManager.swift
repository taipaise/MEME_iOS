//
//  ModelReservationDataManager.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import Alamofire
import UIKit

// API 명세서 맞게 내용 수정하기
class ModelReservationDataManager {
    // MARK: 모델 예약 조회 API
    func getModelReservation(_ viewController: ModelReservationViewController, _ userID: Int = 2) {
        AF.request("https://~~~~~~~~~\(userID)", method: .get, parameters: nil).validate().responseDecodable (of: ModelReservationModel.self) {response in
            switch response.result {
            case .success(let result):
                print("성공")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
