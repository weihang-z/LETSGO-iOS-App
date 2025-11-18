//
//  MainTabBarController.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/16/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    func setupTabs() {
        // Tab 1
        let logsVC = LogTimelineViewController()
        let logsNav = UINavigationController(rootViewController: logsVC)
        logsNav.tabBarItem = UITabBarItem(
            title: "My Logs",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        // Tab 2
        let friendsVC = UIViewController()
        friendsVC.view.backgroundColor = .white
        friendsVC.title = "Friends"
        let friendsNav = UINavigationController(rootViewController: friendsVC)
        friendsNav.tabBarItem = UITabBarItem(
            title: "Friends",
            image: UIImage(systemName: "person.2"),
            selectedImage: UIImage(systemName: "person.2.fill")
        )
        
        // Tab 3
        let groupsVC = UIViewController()
        groupsVC.view.backgroundColor = .white
        groupsVC.title = "Travel Together"
        let groupsNav = UINavigationController(rootViewController: groupsVC)
        groupsNav.tabBarItem = UITabBarItem(
            title: "Travel Together",
            image: UIImage(systemName: "figure.2"),
            selectedImage: UIImage(systemName: "figure.2.fill")
        )
        
        // Tab 4
        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .white
        profileVC.title = "Profile"
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        viewControllers = [logsNav, friendsNav, groupsNav, profileNav]
    }
}
