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
    @IBOutlet private weak var kcalLabel: UILabel! { didSet{ kcalLabel.textColor = .black } }
    @IBOutlet private weak var gramLabel1: UILabel! { didSet{ gramLabel1.textColor = .black } }
    @IBOutlet private weak var gramLabel2: UILabel! { didSet{ gramLabel2.textColor = .black } }
    @IBOutlet private weak var gramLabel3: UILabel! { didSet{ gramLabel3.textColor = .black } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        
        self.colonLabel1.text = ":"
        self.colonLabel2.text = ":"
        self.kcalLabel.text = "kcal"
        self.gramLabel1.text = "g"
        self.gramLabel2.text = "g"
        self.gramLabel3.text = "g"
        
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
        self.nameLabel.text = String(describing: meal.name)
        self.calorieLabel.text = String(describing: meal.calorie)
        self.proteinLabel.text = String(describing: meal.protein)
        self.fatLabel.text = String(describing: meal.fat)
        self.carbohydrateLabel.text = String(describing: meal.carbohydrate)
    }
}
