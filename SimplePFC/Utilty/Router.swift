//
//  Router.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit

final class Router {
    static let shared: Router = .init()
    private init() {}
    
    private var window: UIWindow?
    
    func showRoot(window: UIWindow) {
//        let vc =
//        window.rootViewController = vc
        window.makeKeyAndVisible()
        self.window = window
    }
}
