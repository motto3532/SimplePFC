//
//  FavoriteMealTableViewCell.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/30.
//

import UIKit

final class FavoriteMealTableViewCell: UITableViewCell {
    static var className: String { String(describing: FavoriteMealTableViewCell.self) }
    
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var favoriteMealLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.view.backgroundColor = .white
        self.favoriteMealLabel.text = ""
        self.favoriteMealLabel.textColor = .black
    }
    
    func configure(favoriteMeal: FavoriteMealModel) {
        self.favoriteMealLabel.text = favoriteMeal.name
    }
}
