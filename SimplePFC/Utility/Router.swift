//
//  Router.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/09.
//

import Foundation
import UIKit

final class Router {
    static let shared: Router = .init()
    private init() {}
    
    private var window: UIWindow?
    
    func showRoot(window: UIWindow) {
        let vc = UIStoryboard(name: "Meals", bundle: nil).instantiateInitialViewController() as! MealsViewController
        window.rootViewController = vc
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func showAddMeal(from: UIViewController) {
        let vc = UIStoryboard(name: "AddMeal", bundle: nil).instantiateInitialViewController() as! AddMealViewController
        from.present(vc, animated: true)
    }
    
    func showMeals(from: UIViewController, meal: MealModel) {
        let vc = MealsViewController.makeFromStoryboard(meal: meal)
        from.dismiss(animated: true)
    }
}
