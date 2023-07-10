//
//  MealTableViewCell.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/09.
//

import UIKit

final class MealTableViewCell: UITableViewCell {
    
    static var className: String {
        get {
            String(describing: MealTableViewCell.self)
        }
    }
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var mealNameLabel: UILabel!
    @IBOutlet private weak var calorieLabel: UILabel!
    @IBOutlet private weak var proteinLabel: UILabel!
    @IBOutlet private weak var fatLabel: UILabel!
    @IBOutlet private weak var carbohydrateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        mealNameLabel.text = nil
        calorieLabel.text = nil
        proteinLabel.text = nil
        fatLabel.text = nil
        carbohydrateLabel.text = nil
    }
    
    func configure() {
        
    }
}
