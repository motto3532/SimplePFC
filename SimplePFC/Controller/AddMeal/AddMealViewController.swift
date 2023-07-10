//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/08.
//

import UIKit

final class AddMealViewController: UIViewController {
    @IBOutlet private weak var mealNameTextField: UITextField!
    @IBOutlet private weak var calorieTextField: UITextField! { didSet{setNumberPad(textField: calorieTextField)} }
    @IBOutlet private weak var proteinTextField: UITextField! { didSet{setNumberPad(textField: proteinTextField)} }
    @IBOutlet private weak var fatTextField: UITextField! { didSet{setNumberPad(textField: fatTextField)} }
    @IBOutlet private weak var carbohydrateTextField: UITextField! { didSet{setNumberPad(textField: carbohydrateTextField)} }
    
    @IBOutlet private weak var addButton: UIButton! {
        didSet {
            addButton.addTarget(self, action: #selector(tapAddButton(_sender:)), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func tapAddButton(_sender: UIResponder) {
        guard let mealName = mealNameTextField.text else { return }
        let calorie = calorieTextField.textToInt
        let protein = proteinTextField.textToInt
        let fat = fatTextField.textToInt
        let carbohydrate = carbohydrateTextField.textToInt
        
        let meal = MealModel(name: mealName, carolie: calorie, protein: protein, fat: fat, carbohydrate: carbohydrate)
        
        Router.shared.showMeals(from: self, meal: meal)
    }
    
    private func setNumberPad(textField: UITextField) {
        textField.keyboardType = UIKeyboardType.numberPad
    }
}
