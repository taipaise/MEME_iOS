//
//  SignUpCoordinator.swift
//  MEME
//
//  Created by 이동현 on 4/14/24.
//
import UIKit

protocol SignupCoordinator {
    
    var navigationController: UINavigationController? { get }
    var profileInfo: SignUpProfileInfo { get set }
    
    init(navigationController: UINavigationController?, profileInfo: SignUpProfileInfo)
    
    func start()
}
