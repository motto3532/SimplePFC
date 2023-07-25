//
//  MealsPresenter.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/25.
//

import Foundation
import RealmSwift

//疎結合でコンポーネント間の依存性を最小限に抑える
protocol MealsPresenterInput {
    var numberOfRowsInSection: Int { get }
    func reloadData()
    func addMealBarButtonItemTapped()
    func cellHeight(index: Int) -> CGFloat
    func didSelect(index: Int)
    func cellForRowAt(index: Int) -> UITableViewCell
}
//疎結合でコンポーネント間の依存性を最小限に抑える
protocol MealsPresenterOutput: AnyObject {//class限定プロトコルにすることでweak var使える
    func reload()
    func showMeal(meal: MealModel?)
    func pfcCell() -> PFCTableViewCell
    func mealCell() -> MealTableViewCell
}

final class MealsPresenter {
    //viewController側でもpresenterを保持するから、presenter側から弱参照で保持することで循環参照回避
    private weak var output: MealsPresenterOutput!
    private var meals: [MealModel] = []
    private let realm = try! Realm()
    
    init(output: MealsPresenterOutput) {
        self.output = output
    }
}

extension MealsPresenter: MealsPresenterInput {
    
    var numberOfRowsInSection: Int {
        self.meals.count + 1//PFCセルの分
    }
    
    func reloadData() {
        //meals更新
        self.meals = []
        let realmRegistedData = realm.objects(MealModel.self)
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
    
    func cellForRowAt(index: Int) -> UITableViewCell {
        guard index > 0 else {
            //PFCセル
            let pfcCell = self.output.pfcCell()
            pfcCell.configure(meals: self.meals)
            return pfcCell
        }
        //Mealセル
        let mealCell = self.output.mealCell()
        mealCell.configure(meal: meals[index - 1])
        return mealCell
    }
}
