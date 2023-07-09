//
//  AddMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/08.
//

import UIKit

class AddMealViewController: UIViewController {

    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbohydrateTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.addTarget(self, action: #selector(tapAddButton(_sender:)), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func tapAddButton(_sender: UIResponder) {
        self.dismiss(animated: true)
    }
}
