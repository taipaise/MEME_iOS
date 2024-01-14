//
//  ModelReservationModel.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//
import Foundation

struct ModelReservationModel: Decodable {
    var reservationDate: Date
    var makeupName: String
    var makeupArtist: String
    var location: String
}
