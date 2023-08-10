//
//  PFCTableViewCell.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit

final class PFCTableViewCell: UITableViewCell {
    static var className: String { String(describing: PFCTableViewCell.self) }
    static var cellHeight: CGFloat { 200 }
    
    @IBOutlet private weak var pfcView: UIView! {
        didSet {
            pfcView.setCornerRadius(cornerRadius: CGFloat(30.0))
         }
    }
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var calorieLabel: UILabel!
    @IBOutlet private weak var proteinLabel: UILabel! {didSet{proteinLabel.setBorder()}}
    @IBOutlet private weak var fatLabel: UILabel! {didSet{fatLabel.setBorder()}}
    @IBOutlet private weak var carbohydrateLabel: UILabel! {didSet{carbohydrateLabel.setBorder()}}
    
    private var calorie: String { "calorie" }
    private var protein: String { "protein" }
    private var fat: String { "fat" }
    private var carbohydrate: String { "carbohydrate" }
    
    func configure(meals: [MealModel], date: Date) {
        //tableViewの区切り線を右の画面外に飛ばす
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        //日付表示
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy年M月d日\n(EEEE)"
        self.dateLabel.text = dateFormatter.string(from: date)
        
        //栄養素を集計
        var sumOfNutrients = [calorie: 0, protein: 0, fat: 0, carbohydrate: 0]
        for meal in meals {
            let nutrients = [calorie: meal.calorie, protein: meal.protein, fat: meal.fat, carbohydrate: meal.carbohydrate]
            nutrients.forEach({ (key, value) in sumOfNutrients[key]! += value })
        }
        guard
            let sumOfCalorie = sumOfNutrients[calorie],
            let sumOfProtein = sumOfNutrients[protein],
            let sumOfFat = sumOfNutrients[fat],
            let sumOfCarbohydrate = sumOfNutrients[carbohydrate]
        else { return }
        self.calorieLabel.text = "合計 \(String(describing: sumOfCalorie))kcal"
        self.proteinLabel.text = "P: \(String(describing: sumOfProtein))g"
        self.fatLabel.text = "F: \(String(describing: sumOfFat))g"
        self.carbohydrateLabel.text = "C: \(String(describing: sumOfCarbohydrate))g"
    }
}
