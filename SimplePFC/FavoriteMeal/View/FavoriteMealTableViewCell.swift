//
//  FavoriteMealTableViewCell.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/30.
//

import UIKit

final class FavoriteMealTableViewCell: UITableViewCell {
    static var className: String { String(describing: FavoriteMealTableViewCell.self) }
    
    @IBOutlet private weak var favoriteMealLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.favoriteMealLabel.textColor = .black
        //backgroundViewに適当なview差し込むのが良さそう
        let cellSelectedBackgroundView = UIView()
        cellSelectedBackgroundView.backgroundColor = .yellow
        self.selectedBackgroundView = cellSelectedBackgroundView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isUnchecked()
        self.favoriteMealLabel.text = ""
    }
    
    func configure(favoriteMeal: FavoriteMealModel) {
        self.favoriteMealLabel.text = favoriteMeal.name
    }
    
    func isChecked() {
        self.accessoryType = .checkmark
    }
    
    func isUnchecked() {
        self.accessoryType = .none
    }
}
