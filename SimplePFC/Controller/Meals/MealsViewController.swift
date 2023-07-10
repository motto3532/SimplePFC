//
//  MealsViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/08.
//

import UIKit

final class MealsViewController: UIViewController {
    
    @IBOutlet private weak var addMealButton: UIButton! {
        didSet {
            addMealButton.addTarget(self, action: #selector(tapAddMealButton(_sender:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var pfcView: ShowPFCView!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: MealTableViewCell.className, bundle: nil), forCellReuseIdentifier: MealTableViewCell.className)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.isHidden = true
        }
    }
    
    private var meals: [MealModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func tapAddMealButton(_sender: UIResponder) {
        Router.shared.showAddMeal(from: self)
    }
    
    static func makeFromStoryboard(meal: MealModel) -> MealsViewController {
        let vc = UIStoryboard(name: "Meals", bundle: nil).instantiateInitialViewController() as! MealsViewController
        vc.meals.append(meal)
        return vc
    }
}

extension MealsViewController: UITableViewDelegate {
}

extension MealsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.className) as? MealTableViewCell else {
            fatalError("Fail to load cell.")
        }
        cell.configure(meal: meals[indexPath.row])
        pfcView.configure(meal: meals[indexPath.row])
        return cell
    }
}

