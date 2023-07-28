//
//  MealTableViewCell.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    static var className: String { String(describing: MealTableViewCell.self) }
    
    @IBOutlet private weak var MealLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        MealLabel.text = nil
    }
    
    //時間も追加したい <-ここに時間表示する必要ない
    func configure(meal: MealModel) {
        MealLabel.text = "\(meal.name) -> \(meal.calorie)kcal   \(meal.protein) : \(meal.fat) : \(meal.carbohydrate)"
    }
}
