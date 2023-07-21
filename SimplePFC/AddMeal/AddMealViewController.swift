//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/18.
//

import UIKit

final class AddMealViewController: UIViewController {
   
    @IBOutlet private weak var addMealView: UIView! {didSet{addMealView.setCornerRadius()}}
    
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
    
    //直接値保持してるけどMVCだからいいのかな？
    private var meal: MealModel? = nil
    private var index: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _meal = meal { configureEditMeal(meal: _meal) }
    }
    
    //index貰ってるのなんか無駄な気がする。
    func editMeal(meal: MealModel, index: Int) {
        self.meal = meal
        self.index = index
    }
    
    private func configureEditMeal(meal: MealModel) {
        mealNameTextField.text = meal.name
        calorieTextField.text = String(describing: meal.calorie)
        proteinTextField.text = String(describing: meal.protein)
        fatTextField.text = String(describing: meal.fat)
        carbohydrateTextField.text = String(describing: meal.carbohydrate)
        
        let deleteMealBarButtonItem: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMealBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItems = [deleteMealBarButtonItem]
        
        addMealButton.titleLabel?.text = "編集"
    }
}

@objc private extension AddMealViewController {
    
    func tapAddMealButton(_sender: UIResponder) {
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
        let newMeal = MealModel(name: name, calorie: nutrients[0], protein: nutrients[1], fat: nutrients[2], carbohydrate: nutrients[3])
        
        guard let _index = self.index else {
            //addMeal
            Router.shared.showMeals(from: self, meal: newMeal)
            return
        }
        //editMeal
        Router.shared.showMeals(from: self, meal: newMeal, index: _index)
    }
    
    func deleteMealBarButtonItemTapped(_ sender: UIBarButtonItem) {
        //ここに削除機能入れたいけど、realm使うべき
        print("削除したよ")
    }
}
