//
//  TabBarItemType.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

enum TabBarItemType: Int, CaseIterable {
    case modelHome
    case modelReservation
    case modelMypage //추후 아티스트 마이페이지와 같다면 수정될 수 있음
    case artistHome
    case artistReservation
    case artistMypage
}

extension TabBarItemType {
    // TODO: - 이미지(selected, unselected) 추가
    
    var title: String {
        switch self {
        case .artistHome, .modelHome:
            return "홈"
        case .artistReservation, .modelReservation:
            return "예약"
        case .artistMypage, .modelMypage:
            return "MY"
        }
    }
    
    func setTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: title,
            image: UIImage(systemName: "pencil"), //임시 이미지
            selectedImage: UIImage(systemName: "pencil")
        )
    }
    
}
