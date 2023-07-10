//
//  ShowPFCView.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/09.
//

import UIKit

class ShowPFCView: UIView {
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydrateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        loadNib()
        
        calorieLabel.text = "カロリー：100kcal"
        proteinLabel.text = "タンパク質：20g"
        fatLabel.text = "脂質：3g"
        carbohydrateLabel.text = "炭水化物：10g"
    }
    
    private func loadNib() {
        guard let view = UINib(nibName: "ShowPFCView", bundle: nil).instantiate(withOwner: self).first as? UIView else {
            fatalError("Fail to load FooView from Nib.")
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
}
