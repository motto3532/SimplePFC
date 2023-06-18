//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/06/16.
//

import UIKit

class AddMealViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbohydrateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodNameTextField.delegate = self
        proteinTextField.delegate = self
        fatTextField.delegate = self
        carbohydrateTextField.delegate = self
        
        //キーボードを数字のみにする
        proteinTextField.keyboardType = UIKeyboardType.numberPad
        fatTextField.keyboardType = UIKeyboardType.numberPad
        carbohydrateTextField.keyboardType = UIKeyboardType.numberPad
        
    }
    
    //食事内容を格納する変数
    var meal: (Name: String, protein: Int, fat: Int, carbohydrate: Int) = ("", 0, 0, 0)
    
    @IBAction func addButtonAction(_ sender: Any) {
        //食事内容をtextField毎に格納
        //食事名
        if let foodName = foodNameTextField.text {
            meal.Name = foodName
        }
        //タンパク質
        if let protein = proteinTextField.text {
            meal.protein = Int(protein) ?? 0
        }
        //脂質
        if let fat = fatTextField.text {
            meal.fat = Int(fat) ?? 0
        }
        //炭水化物
        if let carbohydrate = carbohydrateTextField.text {
            meal.carbohydrate = Int(carbohydrate) ?? 0
        }
        
        //contentViewControllerに値を渡す処理
        let contentView = ContentViewController()
        contentView.mealContents.append(meal)
        self.dismiss(animated: true)
    }
    
    //文字キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
