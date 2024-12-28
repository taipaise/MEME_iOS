//
//  BusinessVerificationDTO.swift
//  MEME
//
//  Created by 이동현 on 2/2/24.
//

import Foundation

// MARK: - BusinessVerificationDTO
struct BusinessVerificationDTO: Codable {
    let requestCnt: Int
    let code: String
    let data: [BusinessVerificationData]

    enum CodingKeys: String, CodingKey {
        case requestCnt = "request_cnt"
        case code = "status_code"
        case data
    }
}

// MARK: - BusinessVerificationData
struct BusinessVerificationData: Codable {
    let bNo: String
    let valid: String
    let validMsg: String
    let requestParam: RequestParam

    enum CodingKeys: String, CodingKey {
        case bNo = "b_no"
        case valid
        case validMsg = "valid_msg"
        case requestParam = "request_param"
    }
}

// MARK: - RequestParam
struct RequestParam: Codable {
    let bNo: String
    let startDt: String
    let pNm: String
    let pNm2: String
    let bNm: String
    let corpNo: String
    let bType: String
    let bSector: String
    let bAdr: String

    enum CodingKeys: String, CodingKey {
        case bNo = "b_no"
        case startDt = "start_dt"
        case pNm = "p_nm"
        case pNm2 = "p_nm2"
        case bNm = "b_nm"
        case corpNo = "corp_no"
        case bType = "b_type"
        case bSector = "b_sector"
        case bAdr = "b_adr"
    }
}
