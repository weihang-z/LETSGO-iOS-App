//
//  SceneDelegate.swift
//  LETSGO ios App
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create window
        window = UIWindow(windowScene: windowScene)
        
        // Create the Friend's Log view controller
        let friendLogVC = FriendLogViewController()
        
        // Embed in navigation controller
        let navigationController = UINavigationController(rootViewController: friendLogVC)
        
        // Create tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]
        
        // Set up tab bar item
        navigationController.tabBarItem = UITabBarItem(title: "Friend's Log", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        // Set root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
