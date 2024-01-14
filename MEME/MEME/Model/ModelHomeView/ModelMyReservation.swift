//
//  ModelMyReservation.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

// MARK: - Model My Reservation Structure
struct  ModelMyReservation {
    var date: String
    var time: String
    var makeupName: String
    var artistName: String
    var location: String
}

// MARK: - Model My Reservation Service
class ModelMyReservationService {
    // 임시 데이터
    static let shared = ModelMyReservationService()
    
    var reservations: [ModelMyReservation] = [
        ModelMyReservation(date: "2024-01-12", time: "18:00", makeupName: "면접 메이크업",artistName: "가나다", location: "서울시 동작구"),
        ModelMyReservation(date: "2024-01-13", time: "10:00", makeupName: "면접 메이크업",artistName: "마바사", location: "서울시 관악구"),
        ModelMyReservation(date: "2024-01-13", time: "11:00", makeupName: "면접 메이크업",artistName: "아자차", location: "서울시 구로구")

    ]
    
    // 예약 데이터 확인
    func hasModelMyReservation() -> Bool {
        return !reservations.isEmpty
    }
    
    // 예약 데이터 호출
    func fetchModelMyReservation() -> [ModelMyReservation] {
        return reservations
    }
}
