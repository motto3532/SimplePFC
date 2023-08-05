//
//  AddMealPresenter.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/25.
//

import Foundation

protocol AddMealPresenterInput {
    func viewDidLoad()
    func addMealButtonTapped(favorite: Bool, time: Date, name: String?, calorie: String?, protein: String?, fat: String?, carbohydrate: String?)
    func deleteMealButtonTapped()
    func favoriteMealBarButtonItemTapped()
    func synthesizeFavoriteMeals(favoriteMeals: [FavoriteMealModel]) -> FavoriteMealModel
}

protocol AddMealPresenterOutput: AnyObject {
    func configure(meal: MealModel)
    func configure(favoriteMeal: FavoriteMealModel)
    func emptyAlert()
    func goBack()
    func deleteAlert(action: @escaping () -> Void)
    func showFavoriteMeals()
}

final class AddMealPresenter {
    private weak var output: AddMealPresenterOutput!
    private let meal: MealModel?
    private let favoriteMeal: FavoriteMealModel?
    private let favoriteMeals: [FavoriteMealModel]?
    private let realm: MealRealm
    
    init(output: AddMealPresenterOutput, meal: MealModel?, favoriteMeal: FavoriteMealModel?, favoriteMeals: [FavoriteMealModel]?, realm: MealRealm = MealRealm.shared) {
        self.output = output
        self.meal = meal
        self.favoriteMeal = favoriteMeal
        self.favoriteMeals = favoriteMeals
        self.realm = realm
    }
}

extension AddMealPresenter: AddMealPresenterInput {
    
    func viewDidLoad() {
        if let _meal = self.meal {
            //mealに値があれば編集画面
            self.output.configure(meal: _meal)
            
        } else if let _favoriteMeal = self.favoriteMeal {
            //お気に入り単選択
            self.output.configure(favoriteMeal: _favoriteMeal)
            
        } else if let _favoriteMeals = self.favoriteMeals {
            //お気に入り複数選択
            let favMeal = FavoriteMealModel()
            favMeal.name = ""
            favMeal.calorie = 0
            favMeal.protein = 0
            favMeal.fat = 0
            favMeal.carbohydrate = 0
            
            for favoriteMeal in _favoriteMeals {
                favMeal.name += favMeal.name.isEmpty ? favoriteMeal.name : "+\(favoriteMeal.name)"
                favMeal.calorie += favoriteMeal.calorie
                favMeal.protein += favoriteMeal.protein
                favMeal.fat += favoriteMeal.fat
                favMeal.carbohydrate += favoriteMeal.carbohydrate
            }
            self.output.configure(favoriteMeal: favMeal)
        }
    }
    
    func addMealButtonTapped(favorite: Bool, time: Date, name: String?, calorie: String?, protein: String?, fat: String?, carbohydrate: String?) {
    //食事内容追加・編集
        guard let _name = name, let _calorie = calorie, let _protein = protein, let _fat = fat, let _carbohydrate = carbohydrate else {
            return
        }
        //名前とカロリー必須
        guard !_name.isEmpty, !_calorie.isEmpty else {
            self.output.emptyAlert()
            return
        }
        
        let nutrients = [_calorie, _protein, _fat, _carbohydrate].map{ Int($0) ?? 0 }
        
        if let meal = self.meal {
            //編集処理
            self.realm.edit(time: time, meal: meal, name: _name, calorie: nutrients[0], protein: nutrients[1], fat: nutrients[2], carbohydrate: nutrients[3])
        } else {
            //追加処理
            let newMeal = MealModel()
            newMeal.time = time
            newMeal.name = _name
            newMeal.calorie = nutrients[0]
            newMeal.protein = nutrients[1]
            newMeal.fat = nutrients[2]
            newMeal.carbohydrate = nutrients[3]
            self.realm.add(meal: newMeal)
        }
        
    //お気に入り登録
        if favorite {
            let favoriteMeal = FavoriteMealModel()
            favoriteMeal.name = _name
            favoriteMeal.calorie = nutrients[0]
            favoriteMeal.protein = nutrients[1]
            favoriteMeal.fat = nutrients[2]
            favoriteMeal.carbohydrate = nutrients[3]
            self.realm.add(favoriteMeal: favoriteMeal)
        }
        
        self.output.goBack()
    }
    
    func deleteMealButtonTapped() {
        /*
         1.PresenterがoutputとしてViewControllerを強参照
         2.viewControllerのdeleteAlertメソッドでAlertがdeleteとしてクロージャを強参照
         3.クロージャがselfとしてPresenterを強参照
         4.1に戻ることで循環参照が発生
         これを避けるために、3のselfへの強参照をweak selfで弱参照に変更
         */
        self.output.deleteAlert {[weak self] () -> Void in
            //アラートの削除ボタンが押されたら実行される
            guard let meal = self?.meal else {return}
            self?.realm.delete(meal: meal)
            self?.output.goBack()
        }
    }
    
    func favoriteMealBarButtonItemTapped() {
        self.output.showFavoriteMeals()
    }
    
    func synthesizeFavoriteMeals(favoriteMeals: [FavoriteMealModel]) -> FavoriteMealModel {
        let favMeal = FavoriteMealModel()
        favMeal.name = ""
        favMeal.calorie = 0
        favMeal.protein = 0
        favMeal.fat = 0
        favMeal.carbohydrate = 0
        
        for favoriteMeal in favoriteMeals {
            favMeal.name += favMeal.name.isEmpty ? favoriteMeal.name : "+\(favoriteMeal.name)"
            favMeal.calorie += favoriteMeal.calorie
            favMeal.protein += favoriteMeal.protein
            favMeal.fat += favoriteMeal.fat
            favMeal.carbohydrate += favoriteMeal.carbohydrate
        }
        
        return favMeal
    }
}
