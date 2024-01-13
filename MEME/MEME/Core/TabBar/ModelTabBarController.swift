//
//  ModelTabBarController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

final class ModelTabBarController: UITabBarController {
    
    private var tabs: [TabBarItemType: UIViewController] = [:]
    
    var label: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTabBarItems()
    }
    
    private func setTabBarItems() {
        tabs = [
            TabBarItemType.modelHome: ModelHomeViewController(),
            TabBarItemType.modelReservation: ModelReservationViewController()//,
//            TabBarItemType.modelMypage: ModelMyMage()
        ]
        
        tabs.forEach { tabType, viewController in
            viewController.tabBarItem = tabType.setTabBarItem()
        }
        let sortedKeys = tabs.sorted { $0.key.rawValue < $1.key.rawValue }
        
        let tabViewControllers = sortedKeys.map { tabs[$0.key] ?? UIViewController() }
        setViewControllers(tabViewControllers, animated: false)
    }
    
    private func setUI() {
        tabBar.backgroundColor = .white
    }
}
