//
//  SceneDelegate.swift
//  Delegate
//
//  Created by 지준용 on 2023/02/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController(rootViewController: TestViewController())

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

