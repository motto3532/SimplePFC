//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/18.
//

import UIKit

class AddMealViewController: UIViewController {
    @IBOutlet weak var mealNameTextField: UITextField!
    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbohydratesTextField: UITextField!
    
    @IBOutlet weak var addMealButton: UIButton! {
        didSet {
            addMealButton.addTarget(self, action: #selector(tapAddMealButton(_sender:)), for: .touchUpInside)
        }
    }
    
    @objc func tapAddMealButton(_sender: UIResponder) {
        print("meal added")
    }
}
