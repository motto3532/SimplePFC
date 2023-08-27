//
//  MealTableViewCell.swift
//  SimplePFC/Users/attorari/Desktop/Swift-beginners/SimplePFC/SimplePFC/Meals/View/MealCell/MealTableViewCell.xib
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit

final class MealTableViewCell: UITableViewCell {
    
    static var className: String { String(describing: MealTableViewCell.self) }
    static var cellHeight: CGFloat { 100 }
    
    @IBOutlet private weak var nameLabel: UILabel! { didSet{ nameLabel.textColor = .black } }
    @IBOutlet private weak var calorieLabel: UILabel! { didSet{ calorieLabel.textColor = .black } }
    @IBOutlet private weak var proteinLabel: UILabel! { didSet{ proteinLabel.textColor = .black } }
    @IBOutlet private weak var fatLabel: UILabel! { didSet{ fatLabel.textColor = .black } }
    @IBOutlet private weak var carbohydrateLabel: UILabel! { didSet{ carbohydrateLabel.textColor = .black } }
    @IBOutlet private weak var colonLabel1: UILabel! { didSet{ colonLabel1.textColor = .black } }
    @IBOutlet private weak var colonLabel2: UILabel! { didSet{ colonLabel2.textColor = .black } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        
        self.colonLabel1.text = ":"
        self.colonLabel2.text = ":"
        
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
        self.proteinLabel.text = "\(String(describing: meal.protein))g"
        self.fatLabel.text = "\(String(describing: meal.fat))g"
        self.carbohydrateLabel.text = "\(String(describing: meal.carbohydrate))g"
    }
}
