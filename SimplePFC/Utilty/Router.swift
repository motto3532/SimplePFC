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
        guard let vc = UIStoryboard(name: "Meals", bundle: nil).instantiateInitialViewController() as? MealsViewController else { return }
        let presenter = MealsPresenter(output: vc)
        vc.inject(presenter: presenter)
        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func showMeal(from: UIViewController, meal: MealModel?) {
        guard let vc = UIStoryboard(name: "AddMeal", bundle: nil).instantiateInitialViewController() as? AddMealViewController else { return }
        vc.configure(meal: meal)
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showMeals(from: UIViewController) {
        guard let vc = from.navigationController?.viewControllers.first as? MealsViewController else { return }
        from.navigationController?.popViewController(animated: true)
    }
}
