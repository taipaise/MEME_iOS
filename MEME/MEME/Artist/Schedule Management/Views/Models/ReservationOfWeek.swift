//
//  ReservationOfWeek.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import Foundation

struct ReservationOfWeek {
    let dayOfWeek: DayOfWeek
    var selectedTime = Set<ReservationTimes>()
}
