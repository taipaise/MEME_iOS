//
//  MEMEError.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import Foundation

public enum MEMEError: Error {
    case failedToParse
    case isNotConnectedToInternet
    case unknown(underlyingError: Error)
    case KeychainError
    case UserDefaultError
}
