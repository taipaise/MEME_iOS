//
//  Coordinator.swift
//  MEME
//
//  Created by 이동현 on 4/7/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }

    init(navigationController: UINavigationController?)
    
    func start()
}
