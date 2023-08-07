//
//  MealTableViewCell.swift
//  SimplePFC/Users/attorari/Desktop/Swift-beginners/SimplePFC/SimplePFC/Meals/View/MealCell/MealTableViewCell.xib
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit

final class MealTableViewCell: UITableViewCell {
    
    static var className: String { String(describing: MealTableViewCell.self) }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var calorieLabel: UILabel!
    @IBOutlet private weak var proteinLabel: UILabel!
    @IBOutlet private weak var fatLabel: UILabel!
    @IBOutlet private weak var carbohydrateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        
        let cellSelectedBackgroundView = UIView()
        cellSelectedBackgroundView.backgroundColor = .systemMint
        self.selectedBackgroundView = cellSelectedBackgroundView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.calorieLabel.text = ""
        self.proteinLabel.text = ""
        self.fatLabel.text = ""
        self.carbohydrateLabel.text = ""
    }
    func configure(meal: MealModel) {
        self.nameLabel.text = "\(meal.name)"
        self.calorieLabel.text = "\(meal.calorie) kcal"
        self.proteinLabel.text = String(describing: meal.protein)
        self.fatLabel.text = String(describing: meal.fat)
        self.carbohydrateLabel.text = String(describing: meal.carbohydrate)
    }
}
