//
//  FavoriteMealPresenter.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/30.
//

import Foundation

protocol FavoriteMealPresenterProtocolInput {
    var numOfFavoriteMeals: Int { get }
    func reloadData()
    func getFavoriteMeal(index: Int) -> FavoriteMealModel
    func didSelect(index: Int)
}

protocol FavoriteMealPresenterProtocolOutput: AnyObject {
    func showMeal(favoriteMeal: FavoriteMealModel)
    func reload()
}

final class FavoriteMealPresenter {
    private weak var output: FavoriteMealPresenterProtocolOutput!
    private var favoriteMeals: [FavoriteMealModel] = []
    private let realm: MealRealm
    
    init(output: FavoriteMealPresenterProtocolOutput!, realm: MealRealm = MealRealm.shared) {
        self.output = output
        self.realm = realm
    }
}

extension FavoriteMealPresenter: FavoriteMealPresenterProtocolInput {
    var numOfFavoriteMeals: Int {
        self.favoriteMeals.count
    }
    
    func reloadData() {
        let realmRegistedData = self.realm.getFavoriteMealsData()
        for data in realmRegistedData {
            self.favoriteMeals.append(data)
        }
    }
    
    func getFavoriteMeal(index: Int) -> FavoriteMealModel {
        return self.favoriteMeals[index]
    }
    
    func didSelect(index: Int) {
        //これ間違ってる。
        self.output.showMeal(favoriteMeal: self.favoriteMeals[index])
    }
}
