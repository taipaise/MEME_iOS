//
//  ArtistTabBarController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

final class ArtistTabBarController: UITabBarController {
    
    private var customTabs: [TabBarItemType: UIViewController] = [:]
//    private var tabs: [TabBarItemType: UINavigationController] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarItems()
        setUI()
    }

    private func setTabBarItems() {
        customTabs = [
            TabBarItemType.artistHome: ArtistHomeViewController(),
            TabBarItemType.artistReservation: ManagementReservationsViewController(),
            TabBarItemType.artistSchedule: ScheduleManagementViewController(),
            TabBarItemType.artistMypage: ArtistMyPageViewController()
        ]

        customTabs.forEach { tabType, navigationController in
            navigationController.tabBarItem = tabType.setTabBarItem()
        }
        let sortedKeys = customTabs.sorted { $0.key.rawValue < $1.key.rawValue }
        
        let tabViewControllers = sortedKeys.map { customTabs[$0.key] ?? UIViewController() }
        setViewControllers(tabViewControllers, animated: false)
    }
    
    private func setUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .mainBold
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
