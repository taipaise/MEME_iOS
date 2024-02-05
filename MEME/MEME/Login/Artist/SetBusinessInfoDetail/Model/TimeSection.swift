//
//  TimeSection.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import Foundation

enum TimeSection: Int {
    case am
    case pm
}

extension TimeSection {
    func getStringValue() -> String {
        switch self {
        case .am:
            return "오전"
        case .pm:
            return "오후"
        }
    }
}
