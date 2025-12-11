//
//  SceneDelegate.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 11/14/25.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var authStateHandle: AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        checkAuthStateAndSetRootViewController()
        
        window.makeKeyAndVisible()
        
        authStateHandle = FirebaseService.shared.addAuthStateListener { [weak self] user in
            self?.handleAuthStateChange(user: user)
        }
    }
    
    private func checkAuthStateAndSetRootViewController() {
        if FirebaseService.shared.isLoggedIn {
            showMainApp()
        } else {
            showAuthScreen()
        }
    }
    
    private func handleAuthStateChange(user: User?) {
        guard window?.rootViewController != nil else { return }
        
        if user != nil {
            if !(window?.rootViewController is MainTabBarController) {
                showMainApp()
            }
        } else {
            if !(window?.rootViewController is SignInViewController) {
                showAuthScreen()
            }
        }
    }
    
    func showMainApp() {
        DispatchQueue.main.async { [weak self] in
            TravelLogDataStore.shared.fetchLogsFromFirebase()
            DataManager.shared.fetchFriends()
            
            let mainVC = MainTabBarController()
            self?.window?.rootViewController = mainVC
            
            if let window = self?.window {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
    
    func showAuthScreen() {
        DispatchQueue.main.async { [weak self] in
            TravelLogDataStore.shared.clearLocalData()
            DataManager.shared.clearData()
            
            let signInVC = SignInViewController()
            signInVC.onSignInSuccess = { [weak self] in
                self?.showMainApp()
            }
            self?.window?.rootViewController = signInVC
            
            if let window = self?.window {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        if let handle = authStateHandle {
            FirebaseService.shared.removeAuthStateListener(handle)
        }
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
