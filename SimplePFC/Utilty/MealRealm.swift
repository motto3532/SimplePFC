//
//  MealRealm.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/25.
//

import RealmSwift

protocol MealRealmProtocol {
    func add(meal: MealModel)
    func edit(meal: MealModel, name: String, calorie: Int, protein: Int, fat: Int, carbohydrate: Int)
    func delete(meal: MealModel)
    func getData() -> Results<MealModel>
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
    
    func edit(meal: MealModel, name: String, calorie: Int, protein: Int, fat: Int, carbohydrate: Int) {
        try? self.realm.write {
            //プロパティを更新するのはトランザクション内
            meal.name = name
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
    
    func getData() -> Results<MealModel> {
        return self.realm.objects(MealModel.self)
    }
}
