//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/18.
//

import UIKit
import RealmSwift

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
    
    private var meal: MealModel?
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mealに値があれば編集、無ければ追加
        guard let _meal = meal else { return }
        //編集
        mealNameTextField.text = _meal.name
        calorieTextField.text = String(describing: _meal.calorie)
        proteinTextField.text = String(describing: _meal.protein)
        fatTextField.text = String(describing: _meal.fat)
        carbohydrateTextField.text = String(describing: _meal.carbohydrate)
        
        let deleteMealBarButtonItem: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMealBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItems = [deleteMealBarButtonItem]
        
        addMealButton.titleLabel?.text = "編集"
    }
    
    func configure(meal: MealModel?) {
        self.meal = meal
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
        
        if let meal = self.meal {
            //編集
            //プロパティを更新するときはトランザクション内で。
            try? realm.write {
                meal.name = name
                meal.calorie = nutrients[0]
                meal.protein = nutrients[1]
                meal.fat = nutrients[2]
                meal.carbohydrate = nutrients[3]
                
                realm.add(meal, update: .modified)
            }
        } else {
            //追加
            let newMeal = MealModel()
            newMeal.name = name
            newMeal.calorie = nutrients[0]
            newMeal.protein = nutrients[1]
            newMeal.fat = nutrients[2]
            newMeal.carbohydrate = nutrients[3]
            
            try? realm.write {
                realm.add(newMeal)
            }
        }
        
        Router.shared.showMeals(from: self)
    }
    
    func deleteMealBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "食事内容を削除しますか？", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除", style: .default) {_ in
            
            guard let meal = self.meal else {return}
            try? self.realm.write {
                self.realm.delete(meal)
            }
            
            Router.shared.showMeals(from: self)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
