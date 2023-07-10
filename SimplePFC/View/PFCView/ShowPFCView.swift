//
//  ShowPFCView.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/09.
//

import UIKit

final class ShowPFCView: UIView {
    @IBOutlet private weak var calorieLabel: UILabel!
    @IBOutlet private weak var proteinLabel: UILabel!
    @IBOutlet private weak var fatLabel: UILabel!
    @IBOutlet private weak var carbohydrateLabel: UILabel!
    
    private var calorie = 0
    private var protein = 0
    private var fat = 0
    private var carbohydrate = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    func configure(meal: MealModel) {
        loadNib()
        
        self.calorie += meal.carolie
        self.protein += meal.protein
        self.fat += meal.fat
        self.carbohydrate += meal.carbohydrate
        
        calorieLabel.text = "カロリー：\(self.calorie)"
        proteinLabel.text = "タンパク質：\(self.protein)g"
        fatLabel.text = "脂質：\(self.fat)g"
        carbohydrateLabel.text = "炭水化物：\(self.carbohydrate)g"
    }
    
    private func loadNib() {
        guard let view = UINib(nibName: "ShowPFCView", bundle: nil).instantiate(withOwner: self).first as? UIView else {
            fatalError("Fail to load FooView from Nib.")
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
}
