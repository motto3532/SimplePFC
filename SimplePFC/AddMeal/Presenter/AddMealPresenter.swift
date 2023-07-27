//
//  AddMealPresenter.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/25.
//

import Foundation

protocol AddMealPresenterInput {
    func viewDidLoad()
    func addMealButtonTapped(name: String?, calorie: String?, protein: String?, fat: String?, carbohydrate: String?)
    func deleteMealButtonTapped()
}

protocol AddMealPresenterOutput: AnyObject {
    func configureEditMeal(meal: MealModel)
    func emptyAlert()
    func goBack()
    func deleteAlert(action: @escaping () -> Void)
}

final class AddMealPresenter {
    private weak var output: AddMealPresenterOutput!
    private let meal: MealModel?
    private let realm: MealRealm
    
    init(output: AddMealPresenterOutput, meal: MealModel?, realm: MealRealm = MealRealm.shared) {
        self.output = output
        self.meal = meal
        self.realm = realm
    }
}

extension AddMealPresenter: AddMealPresenterInput {
    
    func viewDidLoad() {
        //mealに値があれば編集画面
        guard let _meal = meal else {
            return
        }
        self.output.configureEditMeal(meal: _meal)
    }
    
    func addMealButtonTapped(name: String?, calorie: String?, protein: String?, fat: String?, carbohydrate: String?) {
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
            self.realm.edit(meal: meal, name: _name, calorie: nutrients[0], protein: nutrients[1], fat: nutrients[2], carbohydrate: nutrients[3])
        } else {
            //追加処理
            let newMeal = MealModel()
            newMeal.name = _name
            newMeal.calorie = nutrients[0]
            newMeal.protein = nutrients[1]
            newMeal.fat = nutrients[2]
            newMeal.carbohydrate = nutrients[3]
            
            self.realm.add(meal: newMeal)
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
}
