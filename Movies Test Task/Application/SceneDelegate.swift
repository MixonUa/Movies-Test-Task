//
//  SceneDelegate.swift
//  Movies Test Task
//
//  Created by Mixon on 12.11.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = UINavigationController(rootViewController: LaunchViewController())
        window?.makeKeyAndVisible()
    }
}
