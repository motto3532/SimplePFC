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
    func decisionButtonTapped()
}

protocol FavoriteMealPresenterProtocolOutput: AnyObject {
    func showAddMeal(favoriteMeal: FavoriteMealModel, date: Date)
    func emptyAlert()
}

final class FavoriteMealPresenter {
    private weak var output: FavoriteMealPresenterProtocolOutput!
    private var favoriteMeals: [FavoriteMealModel] = []
    private let realm: MealRealm
    private var selectedIndex: [Int] = []
    private let date: Date
    
    init(output: FavoriteMealPresenterProtocolOutput, realm: MealRealm = MealRealm.shared, date: Date) {
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
            self.output.showAddMeal(favoriteMeal: self.favoriteMeals[index], date: self.date)
        }
    }
    
    func decisionButtonTapped() {
        if self.selectedIndex.isEmpty {
            self.output.emptyAlert()
        } else {
            //複数選択
            let combinedFavoriteMeal = FavoriteMealModel()
            combinedFavoriteMeal.name = ""
            combinedFavoriteMeal.amount = ""
            combinedFavoriteMeal.amountRatio = 100
            combinedFavoriteMeal.calorie = 0
            combinedFavoriteMeal.protein = 0
            combinedFavoriteMeal.fat = 0
            combinedFavoriteMeal.carbohydrate = 0
            
            for index in self.selectedIndex {
                combinedFavoriteMeal.name += combinedFavoriteMeal.name.isEmpty ? self.favoriteMeals[index].name : "+\(self.favoriteMeals[index].name)"
                combinedFavoriteMeal.amount += combinedFavoriteMeal.amount.isEmpty ? self.favoriteMeals[index].amount : "+\(self.favoriteMeals[index].amount)"
                combinedFavoriteMeal.calorie += self.favoriteMeals[index].calorie
                combinedFavoriteMeal.protein += self.favoriteMeals[index].protein
                combinedFavoriteMeal.fat += self.favoriteMeals[index].fat
                combinedFavoriteMeal.carbohydrate += self.favoriteMeals[index].carbohydrate
            }
            
            self.output.showAddMeal(favoriteMeal: combinedFavoriteMeal, date: self.date)
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
