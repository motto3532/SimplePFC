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
    
    @IBOutlet private weak var addMealView: UIView! {
        didSet {
            addMealView.setCornerRadius(cornerRadius: CGFloat(30.0))
        }
    }
    
    @IBOutlet private weak var mealNameTextField: UITextField! {
        didSet { mealNameTextField.configure(onlyNumberPad: false) }
    }
    @IBOutlet private weak var calorieTextField: UITextField! {
        didSet {
            calorieTextField.configure(onlyNumberPad: true)
            calorieTextField.textAlignment = .center
        }
    }
    @IBOutlet private weak var proteinTextField: UITextField! {
        didSet {
            proteinTextField.configure(onlyNumberPad: true)
            proteinTextField.textAlignment = .center
        }
    }
    @IBOutlet private weak var fatTextField: UITextField! {
        didSet {
            fatTextField.configure(onlyNumberPad: true)
            fatTextField.textAlignment = .center
        }
    }
    @IBOutlet private weak var carbohydrateTextField: UITextField! {
        didSet {
            carbohydrateTextField.configure(onlyNumberPad: true)
            carbohydrateTextField.textAlignment = .center
        }
    }
    
    @IBOutlet private weak var addMealButton: UIButton! {
        didSet {
            addMealButton.setCornerRadius(cornerRadius: 10)
            addMealButton.addTarget(self, action: #selector(addMealButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private var presenter: AddMealPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        datePicker.preferredDatePickerStyle = .compact
        //datePicker.datePickerMode = .dateAndTimeここうまくいかん
        
        self.presenter.viewDidLoad()
    }
    
    func inject(presenter: AddMealPresenterInput) {
        self.presenter = presenter
    }
}

@objc private extension AddMealViewController {
    
    func addMealButtonTapped(_ sender: UIResponder) {
        self.presenter.addMealButtonTapped(
            favorite: self.favoriteSwitch.isOn,
            date: self.datePicker.date,
            name: self.mealNameTextField.text,
            calorie: self.calorieTextField.text,
            protein: self.proteinTextField.text,
            fat: self.fatTextField.text,
            carbohydrate: self.carbohydrateTextField.text
        )
    }
    
    func deleteMealBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.presenter.deleteMealButtonTapped()
    }
}

extension AddMealViewController: AddMealPresenterOutput {
    //新規
    func configure(date: Date) {
        self.datePicker.date = date
        self.mealNameTextField.text = ""
        self.calorieTextField.text = ""
        self.proteinTextField.text = ""
        self.fatTextField.text = ""
        self.carbohydrateTextField.text = ""
    }
    
    //編集
    func configure(meal: MealModel) {
        self.datePicker.date = meal.date
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
    
    //お気に入り
    func configure(favoriteMeal: FavoriteMealModel, date: Date) {
        self.datePicker.date = date
        self.mealNameTextField.text = favoriteMeal.name
        self.calorieTextField.text = String(describing: favoriteMeal.calorie)
        self.proteinTextField.text = String(describing: favoriteMeal.protein)
        self.fatTextField.text = String(describing: favoriteMeal.fat)
        self.carbohydrateTextField.text = String(describing: favoriteMeal.carbohydrate)
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
}
