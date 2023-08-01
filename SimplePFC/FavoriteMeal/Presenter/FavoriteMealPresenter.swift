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
    func didSelect(index: Int, isChecked: Bool)
    func didDeselect(index: Int)
    func deleteFavoriteMeal(index: Int)
    func selectedFavoriteMeals() -> [FavoriteMealModel]
}

protocol FavoriteMealPresenterProtocolOutput: AnyObject {
    func goBack(favoriteMeal: FavoriteMealModel)
    func reload()
}

final class FavoriteMealPresenter {
    private weak var output: FavoriteMealPresenterProtocolOutput!
    private var favoriteMeals: [FavoriteMealModel] = []
    private let realm: MealRealm
    private var selectedIndex: [Int] = []
    
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
    
    func didSelect(index: Int, isChecked: Bool) {
        if isChecked {
            self.selectedIndex.append(index)
            return
        }
        
        self.output.goBack(favoriteMeal: self.favoriteMeals[index])
    }
    
    func didDeselect(index: Int) {
        self.selectedIndex.removeAll(where: { $0 == index })
    }
    
    func deleteFavoriteMeal(index: Int) {
        self.realm.delete(favoriteMeal: self.favoriteMeals[index])
        self.favoriteMeals.remove(at: index)
    }
    
    func selectedFavoriteMeals() -> [FavoriteMealModel] {
        var selectedFavoriteMeals: [FavoriteMealModel] = []
        for index in self.selectedIndex {
            selectedFavoriteMeals.append(self.favoriteMeals[index])
        }
        return selectedFavoriteMeals
    }
}
