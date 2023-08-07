//
//  FavoriteMealTableViewCell.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/30.
//

import UIKit

final class FavoriteMealTableViewCell: UITableViewCell {
    static var className: String { String(describing: FavoriteMealTableViewCell.self) }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var calorieLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        self.nameLabel.textColor = .black
        
        //選択時の色はbackgroundViewに適当なview差し込むのが良さそう
        let cellSelectedBackgroundView = UIView()
        cellSelectedBackgroundView.backgroundColor = .systemMint
        self.selectedBackgroundView = cellSelectedBackgroundView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isUnchecked()
        self.nameLabel.text = ""
        self.calorieLabel.text = ""
    }
    
    func configure(favoriteMeal: FavoriteMealModel) {
        self.nameLabel.text = favoriteMeal.name
        self.calorieLabel.text = "\(favoriteMeal.calorie) kcal"
    }
    
    func isChecked() {
        self.accessoryType = .checkmark
    }
    
    func isUnchecked() {
        self.accessoryType = .none
    }
}
