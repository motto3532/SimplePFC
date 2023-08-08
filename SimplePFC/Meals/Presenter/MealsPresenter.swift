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
    func getMeals() -> [MealModel]
    func getMeal(index: Int) -> MealModel
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
    private let date: Date
    
    init(output: MealsPresenterOutput, realm: MealRealm = MealRealm.shared, date: Date) {
        self.output = output
        self.realm = realm
        self.date = date
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
        dateFormatter.dateFormat = "yyyy年M月d日\n(EEEE)"
        return dateFormatter.string(from: self.date)
    }
    
    func reloadData() {
        //meals更新
        self.meals = []
        let realmRegistedData = self.realm.getMealsData()
        /*
         表示したいmealの日付をstringに書き換えて検索する準備
        realmに保存されてるtimeは世界標準時だからカレンダーからルーター経由で渡されてきたdateをそのまま使う
         */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateStr = dateFormatter.string(from: self.date)
        //realmデータから表示するmealを検索
        for data in realmRegistedData {
            if dateStr == dateFormatter.string(from: data.date) {
                self.meals.append(data)
            }
        }
        self.output.reload()//reloadData()
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
}
