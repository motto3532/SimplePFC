//
//  MealRealm.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/25.
//

import Foundation
import RealmSwift

protocol MealRealmProtocol {
    func add(meal: MealModel)
    func add(favoriteMeal: FavoriteMealModel)
    func edit(date: Date, meal: MealModel, name: String, amount: String, amountRatio: Int, calorie: Int, protein: Int, fat: Int, carbohydrate: Int)
    func delete(meal: MealModel)
    func delete(favoriteMeal: FavoriteMealModel)
    func getMealsData() -> Results<MealModel>
    func getFavoriteMealsData() -> Results<FavoriteMealModel>
}

final class MealRealm: MealRealmProtocol {
    static let shared: MealRealm = .init()
    private let realm = try! Realm()
    
    private init() {}
    
    func add(meal: MealModel) {
        try? self.realm.write {
            self.realm.add(meal)
        }
    }
    
    func add(favoriteMeal: FavoriteMealModel) {
        try? self.realm.write {
            self.realm.add(favoriteMeal)
        }
    }
    
    func edit(date: Date, meal: MealModel, name: String, amount: String, amountRatio: Int, calorie: Int, protein: Int, fat: Int, carbohydrate: Int) {
        //meal追加
        try? self.realm.write {
            //プロパティを更新するのはトランザクション内
            meal.date = date
            meal.name = name
            meal.amount = amount
            meal.amountRatio = amountRatio
            meal.calorie = calorie
            meal.protein = protein
            meal.fat = fat
            meal.carbohydrate = carbohydrate
            //.modifiedでprimaryKey合えば書き換えしてくれる
            self.realm.add(meal, update: .modified)
        }
    }
    
    func delete(meal: MealModel) {
        try? self.realm.write {
            self.realm.delete(meal)
        }
    }
    
    func delete(favoriteMeal: FavoriteMealModel) {
        try? self.realm.write {
            self.realm.delete(favoriteMeal)
        }
    }
    
    func getMealsData() -> Results<MealModel> {
        return self.realm.objects(MealModel.self)
    }
    
    func getFavoriteMealsData() -> Results<FavoriteMealModel> {
        return self.realm.objects(FavoriteMealModel.self)
    }
}
