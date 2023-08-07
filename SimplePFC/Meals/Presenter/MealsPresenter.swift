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
    func getDate() -> String
    func reloadData()
    func addMealBarButtonItemTapped()
    func favoriteMealBarButtonItemTapped()
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
    func showAddMeal(meal: MealModel?)
    func showFavoriteMeal()
}

final class MealsPresenter {
    //viewController側でもpresenterを保持するから、presenter側から弱参照で保持することで循環参照回避
    private weak var output: MealsPresenterOutput!
    private var meals: [MealModel] = []
    private let realm: MealRealm
    private let time: Date
    
    init(output: MealsPresenterOutput, realm: MealRealm = MealRealm.shared, time: Date) {
        self.output = output
        self.realm = realm
        self.time = time
    }
}

extension MealsPresenter: MealsPresenterInput {
    
    var numberOfRowsInSection: Int {
        self.meals.count + 1//PFCセルの分
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy年M月d日(EEEE)"
        return dateFormatter.string(from: self.time)
    }
    
    func reloadData() {
        //meals更新
        self.meals = []
        let realmRegistedData = self.realm.getMealsData()
        //meals画面に表示する日付をstringに書き換え
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let timeStr = dateFormatter.string(from: self.time)
        //realmデータから表示するmealを検索
        for data in realmRegistedData {
            if timeStr == dateFormatter.string(from: data.time) {
                self.meals.append(data)
            }
        }
        //reloadData()
        self.output.reload()
    }
    
    func addMealBarButtonItemTapped() {
        self.output.showAddMeal(meal: nil)
    }
    
    func favoriteMealBarButtonItemTapped() {
        self.output.showFavoriteMeal()
    }
    
    func cellHeight(index: Int) -> CGFloat {
        guard index > 0 else {
            //PFCセル
            return 200
        }
        //Mealセル
        return 80
    }
    
    func didSelect(index: Int) {
        guard index > 0 else { return }
        let meal = self.meals[index - 1]//PFCセルの分
        self.output.showAddMeal(meal: meal)
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
