//
//  MealsViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit
import RealmSwift

final class MealsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: PFCTableViewCell.className, bundle: nil), forCellReuseIdentifier: PFCTableViewCell.className)
            tableView.register(UINib.init(nibName: MealTableViewCell.className, bundle: nil), forCellReuseIdentifier: MealTableViewCell.className)
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.backgroundColor = .white
        }
    }
    
    private var meals: [MealModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addMealBarButtonItem: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addMealBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addMealBarButtonItem]
    }
    
    @objc private func addMealBarButtonItemTapped(_ sender: UIBarButtonItem) {
        Router.shared.showMeal(from: self)
    }
    
    func configure() {
        //appendするだけだと編集処理の後に同じmealが増えるからrealm読み取りかな？
        //filterメソッドとかで置換してもいいけど、addとeditで場合分けだるそう
        let realm = try! Realm()
        let realmRegistedData = realm.objects(MealModel.self)
        for data in realmRegistedData {
            self.meals.append(data)
        }
        
        tableView.reloadData()
    }
}

extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //PFCセル
        guard indexPath.row > 0 else {
            return 200
        }
        //Mealセル
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.showMeal(from: self, meal: meals[indexPath.row - 1])//PFCセルの分
    }
}

extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count + 1//PFCセルの分
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //PFCセル
        guard indexPath.row > 0 else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PFCTableViewCell.className) as? PFCTableViewCell else {
                fatalError()
            }
            cell.configure(meals: meals)
            return cell
        }
        
        //Mealセル
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.className) as? MealTableViewCell else {
            fatalError()
        }
        cell.configure(meal: meals[indexPath.row - 1])
        return cell
        
    }
}
