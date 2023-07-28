//
//  SceneDelegate.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/06/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.frame = UIScreen.main.bounds
        Router.shared.showRoot(window: window)
    }
}

