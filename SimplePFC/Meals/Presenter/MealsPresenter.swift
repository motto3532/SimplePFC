//
//  MealsPresenter.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/25.
//

import Foundation

//疎結合でコンポーネント間の依存性を最小限に抑える
protocol MealsPresenterInput {
    var numberOfSection: Int { get }
    func numberOfRowsInSection(section: Int) -> Int
    func titleForHeaderInSection(section: Int) -> String?
    func getDate() -> String
    func reloadData()
    func addMealBarButtonItemTapped()
    func favoriteMealBarButtonItemTapped()
    func cellHeight(section: Int) -> CGFloat
    func didSelect(section: Int, row: Int)
    func getMeals() -> [MealModel]
    func getMeal(section: Int, row: Int) -> MealModel
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
    //typealiasで型として定義
    private typealias SectionRowPair = (section: String, row: [MealModel])
    private var sectionRowPairs: [SectionRowPair] = []
    
    init(output: MealsPresenterOutput, realm: MealRealm = MealRealm.shared, date: Date) {
        self.output = output
        self.realm = realm
        self.date = date
    }
}

extension MealsPresenter: MealsPresenterInput {
    var numberOfSection: Int {
        self.sectionRowPairs.count + 1//PFCセルの分
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == 0 { return 1 }//PFCセルの分
        return self.sectionRowPairs[section - 1].row.count
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        if section == 0 { return nil }//PFCセルの分
        return "\(self.sectionRowPairs[section - 1].section):00〜"
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy年M月d日\n(EEEE)"
        return dateFormatter.string(from: self.date)
    }
    
    func reloadData() {
        self.meals = []
        self.sectionRowPairs = []
        let realmRegistedData = self.realm.getMealsData()
        //表示するmealは日付が一致するもの
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateStr = dateFormatter.string(from: self.date)
        //realmデータから表示するmealを検索
        for data in realmRegistedData {
            if dateStr == dateFormatter.string(from: data.date) {
                self.meals.append(data)
            }
        }
        
        //mealsを時間ごとにセクションで分ける
        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "ja_JP")
        dateFormatter2.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter2.dateFormat = "H"//24時間
        for meal in self.meals {
            let time = dateFormatter2.string(from: meal.date)
            //すでに時間がsectionとして格納されているか検索
            if let existingSectionIndex = sectionRowPairs.firstIndex(where: { $0.section == time }) {
                sectionRowPairs[existingSectionIndex].row.append(meal)
            } else {
                //時間がsectionに格納されていなければ新規追加
                sectionRowPairs.append((time, [meal]))
            }
        }
        //時間ごとに分けたmealsを時間順に並び替え
        sectionRowPairs.sort(by: {
            //sectionRowPairs.sectionは"H"状態で格納されてるから、一旦Int型に直して比較できるようにする
            guard let former = Int($0.section), let latter = Int($1.section) else { fatalError() }
            return former < latter//前に格納される時間の方が小さくなる
        })
        
        self.output.reload()//reloadData()
    }
    
    func addMealBarButtonItemTapped() {
        self.output.showAddMeal(meal: nil)
    }
    
    func favoriteMealBarButtonItemTapped() {
        self.output.showFavoriteMeal()
    }
    
    func cellHeight(section: Int) -> CGFloat {
        if section == 0 {
            //PFCセル
            return 200
        }
        //Mealセル
        return 80
    }
    
    func didSelect(section: Int, row: Int) {
        guard section > 0 else { return }
        let meal = self.sectionRowPairs[section - 1].row[row]//PFCセルの分
        self.output.showAddMeal(meal: meal)
    }
    
    func getMeals() -> [MealModel] {
        return self.meals
    }
    
    func getMeal(section: Int, row: Int) -> MealModel {
        return self.sectionRowPairs[section - 1].row[row]//PFCセルの分
    }
}
