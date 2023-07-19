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
    
    func showAddMeal(from: UIViewController, meal: MealModel? = nil, index: Int? = nil) {
        guard let vc = UIStoryboard(name: "AddMeal", bundle: nil).instantiateInitialViewController() as? AddMealViewController else { return }
        if let _meal = meal, let _index = index {
            vc.editMeal(meal: _meal, index: _index)
        }
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showMeals(from: UIViewController, meal: MealModel, index: Int? = nil) {
        guard let rootVc = from.navigationController?.viewControllers.first as? MealsViewController else { return }
        rootVc.addMeal(meal: meal, index: index)
        from.navigationController?.popViewController(animated: true)
    }
}
