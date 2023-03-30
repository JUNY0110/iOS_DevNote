//
//  SceneDelegate.swift
//  Coordinator
//
//  Created by 지준용 on 2023/03/23.//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)

        let navigationController = UINavigationController()
        self.window?.rootViewController = navigationController

        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        window?.makeKeyAndVisible()
    }
}

