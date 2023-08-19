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
        guard let vc = UIStoryboard(name: "Calendar", bundle: nil).instantiateInitialViewController() as? CalendarViewController else { return }
        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func showMeals(from: UIViewController, date: Date) {
        guard let vc = UIStoryboard(name: "Meals", bundle: nil).instantiateInitialViewController() as? MealsViewController else { return }
        let presenter = MealsPresenter(output: vc, date: date)
        vc.inject(presenter: presenter)
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAddMeal(from: UIViewController, meal: MealModel? = nil, favoriteMeal: FavoriteMealModel? = nil, date: Date?) {
        //Meals画面-> 新規・編集-> meal?,date?
        //お気に入り画面-> お気に入り-> favoriteMeal,date
        guard let vc = UIStoryboard(name: "AddMeal", bundle: nil).instantiateInitialViewController() as? AddMealViewController else { return }
        let presenter = AddMealPresenter(output: vc, meal: meal, favoriteMeal: favoriteMeal, date: date)
        vc.inject(presenter: presenter)
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goBack(from: UIViewController) {
        //Meals画面取得
        guard let vc = from.navigationController?.viewControllers[1] else { return }
        from.navigationController?.popToViewController(vc, animated: true)
    }
    
    func showCalendar(from: UIViewController) {
        guard let vc = UIStoryboard(name: "Calendar", bundle: nil).instantiateInitialViewController() as? CalendarViewController else { return }
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showFavoriteMeals(from: UIViewController, date: Date) {
        guard let vc = UIStoryboard(name: "FavoriteMeal", bundle: nil).instantiateInitialViewController() as? FavoriteMealViewController else { return }
        let presenter = FavoriteMealPresenter(output: vc, date: date)
        vc.inject(presenter: presenter)
        from.navigationController?.pushViewController(vc, animated: true)
    }
}
