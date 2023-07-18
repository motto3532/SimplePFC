//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/18.
//

import UIKit

final class AddMealViewController: UIViewController {
   
    @IBOutlet weak var addMealView: UIView! {didSet{addMealView.setCornerRadius()}}
    
    @IBOutlet private weak var mealNameTextField: UITextField! {
        didSet { mealNameTextField.configure(onlyNumberPad: false) }
    }
    @IBOutlet private weak var calorieTextField: UITextField! {
        didSet { calorieTextField.configure(onlyNumberPad: true) }
    }
    @IBOutlet private weak var proteinTextField: UITextField! {
        didSet { proteinTextField.configure(onlyNumberPad: true) }
    }
    @IBOutlet private weak var fatTextField: UITextField! {
        didSet { fatTextField.configure(onlyNumberPad: true) }
    }
    @IBOutlet private weak var carbohydrateTextField: UITextField! {
        didSet { carbohydrateTextField.configure(onlyNumberPad: true) }
    }
    
    @IBOutlet private weak var addMealButton: UIButton! {
        didSet {
            addMealButton.addTarget(self, action: #selector(tapAddMealButton(_sender:)), for: .touchUpInside)
        }
    }
    
    @objc func tapAddMealButton(_sender: UIResponder) {
        guard
            let name = mealNameTextField.text,
            let calorie = calorieTextField.text,
            let protein = proteinTextField.text,
            let fat = fatTextField.text,
            let carbohydrate = carbohydrateTextField.text
        else { return }
        
        guard !name.isEmpty, !calorie.isEmpty else {
            let alert = UIAlertController(title: "未記入の項目があります", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let nutrients = [calorie, protein, fat, carbohydrate].map{ Int($0) ?? 0 }
        let meal = MealModel(name: name, calorie: nutrients[0], protein: nutrients[1], fat: nutrients[2], carbohydrate: nutrients[3])
        
        Router.shared.showMeals(from: self, meal: meal)
    }
}
