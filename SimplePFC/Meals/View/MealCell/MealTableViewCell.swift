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
    
    func configure(meal: MealModel) {
        self.MealLabel.text = "\(meal.name) -> \(meal.calorie)kcal   \(meal.protein) : \(meal.fat) : \(meal.carbohydrate)"
    }
}
