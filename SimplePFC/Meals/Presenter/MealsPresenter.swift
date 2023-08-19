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
    var getDate: Date { get }
    func deleteMeal(indexPath: IndexPath, deleteRow: () -> Void, deleteSection: () -> Void)
    func numberOfRowsInSection(section: Int) -> Int
    func titleForHeaderInSection(section: Int) -> String?
    func reloadData()
    func addMealBarButtonItemTapped()
    func favoriteMealBarButtonItemTapped()
    func heightForRowAt(indexPath: IndexPath) -> CGFloat
    func didSelect(indexPath: IndexPath)
//    func getMeals() -> [MealModel]
//    func getMeal(indexPath: IndexPath) -> MealModel
    func cellForRowAt(indexPath: IndexPath, pfcCell: ([MealModel], Date) -> Void, mealCell: (MealModel) -> Void)
}
//疎結合でコンポーネント間の依存性を最小限に抑える
protocol MealsPresenterOutput: AnyObject {//class限定プロトコルにすることでweak var使える
    var pfcCellHeight: CGFloat { get }
    var mealCellHeight: CGFloat { get }
    func reload()
    func showAddMeal(meal: MealModel?, date: Date?)
    func showFavoriteMeal(date: Date)
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
    //セルの高さのキャッシュ
    private let heightCache: [IndexPath: CGFloat] = [:]
    
    init(output: MealsPresenterOutput, realm: MealRealm = MealRealm.shared, date: Date) {
        self.output = output
        self.realm = realm
        self.date = date
    }
}

extension MealsPresenter: MealsPresenterInput {
    func deleteMeal(indexPath: IndexPath, deleteRow: () -> Void, deleteSection: () -> Void) {
        //realmから消す
        self.realm.delete(meal: self.sectionRowPairs[indexPath.section - 1].row[indexPath.row])
        
        if self.sectionRowPairs[indexPath.section - 1].row.count == 1 {
            //対象セクションの中の食事内容が1つならセクションごと消す
            self.sectionRowPairs.remove(at: indexPath.section - 1)
            deleteSection()
        } else {
            //それ以外は対象のmealだけ消す
            self.sectionRowPairs[indexPath.section - 1].row.remove(at: indexPath.row)
            deleteRow()
        }
    }
    
    var numberOfSection: Int {
        self.sectionRowPairs.count + 1//PFCセルの分
    }
    
    var getDate: Date {
        self.date
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == 0 { return 1 }//PFCセルの分
        return self.sectionRowPairs[section - 1].row.count
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        if section == 0 { return nil }//PFCセルの分
        return "\(self.sectionRowPairs[section - 1].section):00〜"
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
        //新規
        self.output.showAddMeal(meal: nil, date: self.date)
    }
    
    func favoriteMealBarButtonItemTapped() {
        self.output.showFavoriteMeal(date: self.date)
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        //キャッシュがあればそれを返す
        if let height = self.heightCache[indexPath] {
            return height
        }
        
        if indexPath.section == 0 {
            //PFCセル
            return self.output.pfcCellHeight
        } else {
            //Mealセル
            return self.output.mealCellHeight
        }
    }
    
    func didSelect(indexPath: IndexPath) {
        //編集
        guard indexPath.section > 0 else { return }
        let meal = self.sectionRowPairs[indexPath.section - 1].row[indexPath.row]//PFCセルの分
        self.output.showAddMeal(meal: meal, date: nil)//編集だからdateはnil
    }
    
//    func getMeals() -> [MealModel] {
//        return self.meals
//    }
//
//    func getMeal(indexPath: IndexPath) -> MealModel {
//        return self.sectionRowPairs[indexPath.section - 1].row[indexPath.row]//PFCセルの分
//    }
    
    func cellForRowAt(indexPath: IndexPath, pfcCell: ([MealModel], Date) -> Void, mealCell: (MealModel) -> Void) {
        if indexPath.section == 0 {
            pfcCell(self.meals, self.date)
        } else {
            mealCell(self.sectionRowPairs[indexPath.section - 1].row[indexPath.row])//PFCセルの分
        }
    }
}
