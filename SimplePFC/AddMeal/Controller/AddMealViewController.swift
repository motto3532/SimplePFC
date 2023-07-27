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
            addMealButton.addTarget(self, action: #selector(addMealButtonTapped(_sender:)), for: .touchUpInside)
        }
    }
    
    private var presenter: AddMealPresenterInput!
    
    private var meal: MealModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }
    
    func inject(presenter: AddMealPresenterInput) {
        self.presenter = presenter
    }
}

@objc private extension AddMealViewController {
    
    func addMealButtonTapped(_sender: UIResponder) {
        self.presenter.addMealButtonTapped(
            name: mealNameTextField.text,
            calorie: calorieTextField.text,
            protein: proteinTextField.text,
            fat: fatTextField.text,
            carbohydrate: carbohydrateTextField.text
        )
    }
    
    func deleteMealBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.presenter.deleteMealButtonTapped()
    }
}

extension AddMealViewController: AddMealPresenterOutput {
    
    func configureEditMeal(meal: MealModel) {
        mealNameTextField.text = meal.name
        calorieTextField.text = String(describing: meal.calorie)
        proteinTextField.text = String(describing: meal.protein)
        fatTextField.text = String(describing: meal.fat)
        carbohydrateTextField.text = String(describing: meal.carbohydrate)
        //削除ボタン
        let deleteMealBarButtonItem: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMealBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItems = [deleteMealBarButtonItem]
        //編集ボタン
        addMealButton.titleLabel?.text = "編集"
    }
    
    func emptyAlert() {
        let alert = UIAlertController(title: "未記入の項目があります", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func showMeals() {
        Router.shared.showMeals(from: self)
    }
    
    func deleteAlert(action: @escaping () -> Void) {
        let alert = UIAlertController(title: "食事内容を削除しますか？", message: nil, preferredStyle: .alert)
        //deleteとしてクロージャがAlertに渡されるため、deleteAlertメソッドのスコープ外に保持されることになる。つまりクロージャに'@escaping'が必要(このメソッドの引数のとこ)
        let delete = UIAlertAction(title: "削除", style: .default) {(UIAlertAction) -> Void in//省略したい
            action()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
