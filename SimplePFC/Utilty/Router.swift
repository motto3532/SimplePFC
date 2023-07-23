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
        let nc = UINavigationController(rootViewController: vc)
        nc.configure()
        window.rootViewController = nc
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func showMeal(from: UIViewController, meal: MealModel? = nil) {
        guard let vc = UIStoryboard(name: "AddMeal", bundle: nil).instantiateInitialViewController() as? AddMealViewController else { return }
        //編集
        if let _meal = meal { vc.configure(meal: _meal) }
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showMeals(from: UIViewController) {
        guard let vc = from.navigationController?.viewControllers.first as? MealsViewController else { return }
        vc.configure()
        from.navigationController?.popViewController(animated: true)
    }
}
