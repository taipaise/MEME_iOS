//
//  Collection+.swift
//  MEME
//
//  Created by 이동현 on 7/14/24.
//

import Foundation
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
