//
//  NotificationType.swift
//  MEME
//
//  Created by 이동현 on 7/15/24.
//

import UIKit

enum NotificationType {
    case general
}

extension NotificationType {
    var icon: UIImage {
        switch self {
        case .general:
            return .generalNoti
        }
    }
}
