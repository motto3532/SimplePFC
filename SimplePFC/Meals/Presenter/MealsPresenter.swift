//
//  MealsPresenter.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/25.
//

import Foundation

//疎結合でコンポーネント間の依存性を最小限に抑える
protocol MealsPresenterInput {
    var numberOfRowsInSection: Int { get }
    func reloadData()
    func addMealBarButtonItemTapped()
    func cellHeight(index: Int) -> CGFloat
    func didSelect(index: Int)
    //下2つは返す値の型が違うから別で定義してるけど、ジェネリクス使えば1つにまとめられそう
    func getMeals() -> [MealModel]
    func getMeal(index: Int) -> MealModel
    /*
     無理やり引っ張ってきたやつ
     func cellForRowAt(index: Int, pfcCell: ([MealModel]) -> Void, mealCell: (MealModel) -> Void)
     */
}
//疎結合でコンポーネント間の依存性を最小限に抑える
protocol MealsPresenterOutput: AnyObject {//class限定プロトコルにすることでweak var使える
    func reload()
    func showMeal(meal: MealModel?)
}

final class MealsPresenter {
    //viewController側でもpresenterを保持するから、presenter側から弱参照で保持することで循環参照回避
    private weak var output: MealsPresenterOutput!
    private var meals: [MealModel] = []
    private let realm: MealRealm
    
    init(output: MealsPresenterOutput, realm: MealRealm = MealRealm.shared) {
        self.output = output
        self.realm = realm
    }
}

extension MealsPresenter: MealsPresenterInput {
    
    var numberOfRowsInSection: Int {
        self.meals.count + 1//PFCセルの分
    }
    
    func reloadData() {
        //meals更新
        self.meals = []
        let realmRegistedData = self.realm.getData()
        for data in realmRegistedData {
            self.meals.append(data)
        }
        //reloadData()
        self.output.reload()
    }
    
    func addMealBarButtonItemTapped() {
        self.output.showMeal(meal: nil)
    }
    
    func cellHeight(index: Int) -> CGFloat {
        guard index > 0 else {
            //PFCセル
            return 200
        }
        //Mealセル
        return 100
    }
    
    func didSelect(index: Int) {
        let meal = self.meals[index - 1]//PFCセルの分
        self.output.showMeal(meal: meal)
    }
    
    func getMeals() -> [MealModel] {
        return self.meals
    }
    
    func getMeal(index: Int) -> MealModel {
        return self.meals[index]
    }
    
    /*
    クロージャで無理やりこっちに処理引っ張ってきたやつ
    func cellForRowAt(index: Int, pfcCell: ([MealModel]) -> Void, mealCell: (MealModel) -> Void) {
        guard index > 0 else {
            pfcCell(self.meals)
            return
        }
        mealCell(self.meals[index - 1])
    }
     */
}
