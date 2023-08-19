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
    func didSelect(index: Int, allowsMultipleSelection: Bool, checkCell: () -> Void, deselectCell: () -> Void)
    func didDeselect(index: Int)
    func deleteFavoriteMeal(index: Int)
    func decisionBarButtonTapped()
}

protocol FavoriteMealPresenterProtocolOutput: AnyObject {
    func showAddMeal(favoriteMeal: FavoriteMealModel?, favoriteMeals: [FavoriteMealModel]?, date: Date)
    func emptyAlert()
}

final class FavoriteMealPresenter {
    private weak var output: FavoriteMealPresenterProtocolOutput!
    private var favoriteMeals: [FavoriteMealModel] = []
    private let realm: MealRealm
    private var selectedIndex: [Int] = []
    private let date: Date
    
    init(output: FavoriteMealPresenterProtocolOutput!, realm: MealRealm = MealRealm.shared, date: Date) {
        self.output = output
        self.realm = realm
        self.date = date
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
    
    func didSelect(index: Int, allowsMultipleSelection: Bool, checkCell: () -> Void, deselectCell: () -> Void) {
        if allowsMultipleSelection {
            //複数選択
            checkCell()
            self.selectedIndex.append(index)
        } else {
            //単選択
            deselectCell()
            self.output.showAddMeal(favoriteMeal: self.favoriteMeals[index], favoriteMeals: nil, date: self.date)
        }
    }
    
    func decisionBarButtonTapped() {
        if self.selectedIndex.isEmpty {
            self.output.emptyAlert()
        } else {
            //複数選択確定
            var selectedFavoriteMeals: [FavoriteMealModel] = []
            for index in self.selectedIndex {
                selectedFavoriteMeals.append(self.favoriteMeals[index])
            }
            self.output.showAddMeal(favoriteMeal: nil, favoriteMeals: selectedFavoriteMeals, date: self.date)
        }
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
