//
//  ModelData.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import UIKit

// MARK: - Model Data Structure
struct ModelData {
    var name: String
    var profileImage: UIImage
}

// MARK: - Model Data Service
class ModelDataService {
    static let shared = ModelDataService()
    
    private(set) var currentModel: ModelData?
    
    init() {
        loadModelData()
    }
    
    private func loadModelData() {
        // 임시 데이터 설정
        currentModel = ModelData(name: "메메최고", profileImage: UIImage(named: "SelectMakeupCardIMG") )
    }
}
