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
    
    private static var calKey: String { "calorie" }
    private static var proKey: String { "protein" }
    private static var fatKey: String { "fat" }
    private static var carKey: String { "carbohydrate" }
    private static var totalPfc:[String: Int] = [calKey: 0, proKey: 0, fatKey: 0, carKey: 0]
    
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
        
        guard
            let cal = ShowPFCView.totalPfc[ShowPFCView.calKey],
            let pro = ShowPFCView.totalPfc[ShowPFCView.proKey],
            let fat = ShowPFCView.totalPfc[ShowPFCView.fatKey],
            let car = ShowPFCView.totalPfc[ShowPFCView.carKey]
        else { return }
        
        ShowPFCView.totalPfc.updateValue(cal + meal.calorie, forKey: ShowPFCView.calKey)
        ShowPFCView.totalPfc.updateValue(pro + meal.protein, forKey: ShowPFCView.proKey)
        ShowPFCView.totalPfc.updateValue(fat + meal.fat, forKey: ShowPFCView.fatKey)
        ShowPFCView.totalPfc.updateValue(car + meal.carbohydrate, forKey: ShowPFCView.carKey)
        
        calorieLabel.text = "カロリー：\(String(describing: ShowPFCView.totalPfc[ShowPFCView.calKey]))"
        proteinLabel.text = "タンパク質：\(String(describing: ShowPFCView.totalPfc[ShowPFCView.proKey]))g"
        fatLabel.text = "脂質：\(String(describing: ShowPFCView.totalPfc[ShowPFCView.fatKey]))g"
        carbohydrateLabel.text = "炭水化物：\(String(describing: ShowPFCView.totalPfc[ShowPFCView.carKey]))g"
    }
    
    private func loadNib() {
        guard let view = UINib(nibName: "ShowPFCView", bundle: nil).instantiate(withOwner: self).first as? UIView else {
            fatalError("Fail to load FooView from Nib.")
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
}
