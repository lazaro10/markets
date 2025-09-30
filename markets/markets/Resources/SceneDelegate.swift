//
//  SceneDelegate.swift
//  moneybase-challenge
//
//  Created by Lázaro Lima dos Santos on 14/07/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(
            rootViewController: TickersBuilder.build()
        )
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
