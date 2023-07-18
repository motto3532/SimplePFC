//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/18.
//

import UIKit

final class AddMealViewController: UIViewController {
    @IBOutlet private weak var mealNameTextField: UITextField! {
        didSet { configureTextField(tf: mealNameTextField, onlyNumberPad: false) }
    }
    @IBOutlet private weak var calorieTextField: UITextField! {
        didSet { configureTextField(tf: calorieTextField, onlyNumberPad: false) }
    }
    @IBOutlet private weak var proteinTextField: UITextField! {
        didSet { configureTextField(tf: proteinTextField, onlyNumberPad: true) }
    }
    @IBOutlet private weak var fatTextField: UITextField! {
        didSet { configureTextField(tf: fatTextField, onlyNumberPad: true) }
    }
    @IBOutlet private weak var carbohydratesTextField: UITextField! {
        didSet { configureTextField(tf: carbohydratesTextField, onlyNumberPad: true) }
    }
    
    @IBOutlet private weak var addMealButton: UIButton! {
        didSet {
            addMealButton.addTarget(self, action: #selector(tapAddMealButton(_sender:)), for: .touchUpInside)
        }
    }
    
    @objc func tapAddMealButton(_sender: UIResponder) {
        print("meal added")
    }
    
    private func configureTextField(tf: UITextField, onlyNumberPad: Bool) {
        tf.backgroundColor = .white
        tf.textColor = .black
        if onlyNumberPad {
            tf.keyboardType = UIKeyboardType.numberPad
        }
    }
}
