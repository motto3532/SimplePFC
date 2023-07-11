//
//  MealsViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit

class MealsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: PFCTableViewCell.className, bundle: nil), forCellReuseIdentifier: PFCTableViewCell.className)
            tableView.register(UINib.init(nibName: MealTableViewCell.className, bundle: nil), forCellReuseIdentifier: MealTableViewCell.className)
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.backgroundColor = .white
        }
    }
    
    private let someMeal = [
        MealModel(name: "きなこ",calorie: 100, protein: 10, fat: 2, carbohydrate: 13),
        MealModel(name: "おこげ",calorie: 200, protein: 2, fat: 16, carbohydrate: 10),
        MealModel(name: "牡蠣",calorie: 100, protein: 10, fat: 2, carbohydrate: 13),
        MealModel(name: "ミートソース",calorie: 200, protein: 2, fat: 16, carbohydrate: 10),
        MealModel(name: "ラーメン",calorie: 100, protein: 10, fat: 2, carbohydrate: 13),
        MealModel(name: "餃子",calorie: 200, protein: 2, fat: 16, carbohydrate: 10)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}

extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row > 0 else { return 200 }
        return 100
    }
}

extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someMeal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PFCTableViewCell.className) as? PFCTableViewCell else { fatalError() }
            cell.configure(meal: someMeal[indexPath.row])
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.className) as? MealTableViewCell else { fatalError() }
            cell.configure(meal: someMeal[indexPath.row - 1])
            
            return cell
        }
    }
}
