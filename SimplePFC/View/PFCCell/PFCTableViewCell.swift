//
//  PFCTableViewCell.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit

class PFCTableViewCell: UITableViewCell {
    static var className: String { String(describing: PFCTableViewCell.self) }
    
    @IBOutlet private weak var pfcView: UIView! {
        didSet {
            pfcView.layer.cornerRadius = 30.0
            pfcView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var calorieLabel: UILabel!
    @IBOutlet private weak var proteinLabel: UILabel! {didSet{setBorder(label: proteinLabel)}}
    @IBOutlet private weak var fatLabel: UILabel! {didSet{setBorder(label: fatLabel)}}
    @IBOutlet private weak var carbohydrateLabel: UILabel! {didSet{setBorder(label: carbohydrateLabel)}}
    
    func configure(meal: MealModel) {
        self.calorieLabel.text = "合計 \(String(describing: meal.calorie))kcal"
        self.proteinLabel.text = "P: \(String(describing: meal.protein))g"
        self.fatLabel.text = "F: \(String(describing: meal.fat))g"
        self.carbohydrateLabel.text = "C: \(String(describing: meal.carbohydrate))g"
    }
    
    private func setBorder(label: UILabel) {
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 20.0
        label.clipsToBounds = true
    }
}
