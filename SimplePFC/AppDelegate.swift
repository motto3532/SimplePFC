//
//  AppDelegate.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/06/10.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.overrideKeyboardAppearance = true
        IQKeyboardManager.shared.keyboardAppearance = .light
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完了"
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = false
        IQKeyboardManager.shared.toolbarTintColor = .systemMint
        IQKeyboardManager.shared.enable = true
        
        UINavigationBar.appearance().tintColor = .systemMint
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

