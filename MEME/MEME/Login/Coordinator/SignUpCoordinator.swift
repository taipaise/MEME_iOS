//
//  SignUpCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/14/24.
//
import UIKit

protocol SignupCoordinator {
    
    var navigationController: UINavigationController? { get }
    var profileInfo: ProfileInfo { get set }
    
    init(navigationController: UINavigationController?, profileInfo: ProfileInfo)
    
    func start()
}
