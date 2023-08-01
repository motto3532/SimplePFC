//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/18.
//

import UIKit

final class AddMealViewController: UIViewController {
    @IBOutlet private weak var favoriteSwitch: UISwitch! {
        didSet { favoriteSwitch.setOn(false, animated: false) }
    }
    //現在時刻ボタン追加したい
    @IBOutlet private weak var datePicker: UIDatePicker!
    
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
            addMealButton.addTarget(self, action: #selector(addMealButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private var presenter: AddMealPresenterInput!
    
    private var meal: MealModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        datePicker.preferredDatePickerStyle = .compact
        //datePicker.datePickerMode = .dateAndTimeここうまくいかん
        
        let favoriteMealBarButton: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(favoriteMealBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = favoriteMealBarButton
        
        self.presenter.viewDidLoad()
    }
    
    func inject(presenter: AddMealPresenterInput) {
        self.presenter = presenter
    }
    
    func configure(favoriteMeal: FavoriteMealModel) {
        self.datePicker.date = Date()
        self.mealNameTextField.text = favoriteMeal.name
        self.calorieTextField.text = String(describing: favoriteMeal.calorie)
        self.proteinTextField.text = String(describing: favoriteMeal.protein)
        self.fatTextField.text = String(describing: favoriteMeal.fat)
        self.carbohydrateTextField.text = String(describing: favoriteMeal.carbohydrate)
    }
    
    func configure(favoriteMeals: [FavoriteMealModel]) {
        let synthesizedFavoriteMeal = self.presenter.synthesizeFavoriteMeals(favoriteMeals: favoriteMeals)
        self.datePicker.date = Date()
        self.mealNameTextField.text = synthesizedFavoriteMeal.name
        self.calorieTextField.text = String(describing: synthesizedFavoriteMeal.calorie)
        self.proteinTextField.text = String(describing: synthesizedFavoriteMeal.protein)
        self.fatTextField.text = String(describing: synthesizedFavoriteMeal.fat)
        self.carbohydrateTextField.text = String(describing: synthesizedFavoriteMeal.carbohydrate)
    }
}

@objc private extension AddMealViewController {
    
    func addMealButtonTapped(_ sender: UIResponder) {
        self.presenter.addMealButtonTapped(
            favorite: favoriteSwitch.isOn,
            time: datePicker.date,
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
    
    func favoriteMealBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.presenter.favoriteMealBarButtonItemTapped()
    }
}

extension AddMealViewController: AddMealPresenterOutput {
    
    func configure(meal: MealModel) {
        self.datePicker.date = meal.time
        self.mealNameTextField.text = meal.name
        self.calorieTextField.text = String(describing: meal.calorie)
        self.proteinTextField.text = String(describing: meal.protein)
        self.fatTextField.text = String(describing: meal.fat)
        self.carbohydrateTextField.text = String(describing: meal.carbohydrate)
        //削除ボタン
        let deleteMealBarButtonItem: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMealBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItems = [deleteMealBarButtonItem]
        //編集ボタン
        self.addMealButton.titleLabel?.text = "編集"
    }
    
    func emptyAlert() {
        let alert = UIAlertController(title: "未記入の項目があります", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func goBack() {
        Router.shared.goBack(from: self)
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
    
    func showFavoriteMeals() {
        Router.shared.showFavoriteMeals(from: self)
    }
}
