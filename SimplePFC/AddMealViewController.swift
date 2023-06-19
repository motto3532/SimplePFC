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
//
//    //食事内容を格納する変数
//    var meal: (Name: String, protein: Int, fat: Int, carbohydrate: Int) = ("", 0, 0, 0)
    
    @IBAction func addButtonAction(_ sender: Any) {
        //食事内容をtextField毎に格納
        //食事名
        if let foodName = foodNameTextField.text {
            UserDefaults.standard.set(foodName, forKey: "name")
        }
        //タンパク質
        if let protein = proteinTextField.text {
            let newProtein = Int(protein) ?? 0
            UserDefaults.standard.set(newProtein, forKey: "protein")
        }
        //脂質
        if let fat = fatTextField.text {
            let newFat = Int(fat) ?? 0
            UserDefaults.standard.set(newFat, forKey: "fat")
        }
        //炭水化物
        if let carbohydrate = carbohydrateTextField.text {
            let newCarbohydrate = Int(carbohydrate) ?? 0
            UserDefaults.standard.set(newCarbohydrate, forKey: "carbohydrate")
        }
        
        //modalを閉じる
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
