//
//  MealsViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/12.
//

import UIKit

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
    
    //init()で初期化するわけじゃないからvarで宣言
    private var presenter: MealsPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        
        //編集ボタン
        let addMealBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addMealBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = addMealBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.reloadData()
    }
    
    func inject(presenter: MealsPresenterInput) {
        self.presenter = presenter
    }
}

@objc private extension MealsViewController {
    func addMealBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.presenter.addMealBarButtonItemTapped()
    }
}

extension MealsViewController: MealsPresenterOutput {
    
    func reload() {
        self.tableView.reloadData()
    }
    
    func showMeal(meal: MealModel?) {
        Router.shared.showMeal(from: self, meal: meal)
    }
}

extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.presenter.cellHeight(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.presenter.didSelect(index: indexPath.row)
    }
}

extension MealsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row > 0 else {
            guard let pfcCell = tableView.dequeueReusableCell(withIdentifier: PFCTableViewCell.className) as? PFCTableViewCell else {
                fatalError()
            }
            pfcCell.configure(meals: self.presenter.getMeals())
            return pfcCell
        }
        
        guard let mealCell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.className) as? MealTableViewCell else {
            fatalError()
        }
        mealCell.configure(meal: self.presenter.getMeal(index: indexPath.row - 1))
        return mealCell
        
        /*
        無理やりpresenterに処理渡したやつだけどめちゃわかりにくい
        var cell: UITableViewCell?
        
        let makePfcCell = {(meals: [MealModel]) -> Void in
            guard let pfcCell = tableView.dequeueReusableCell(withIdentifier: PFCTableViewCell.className) as? PFCTableViewCell else {
                fatalError()
            }
            pfcCell.configure(meals: meals)
            
            cell = pfcCell
        }
        let makeMealCell = {(meal: MealModel) -> Void in
            guard let mealCell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.className) as? MealTableViewCell else {
                fatalError()
            }
            mealCell.configure(meal: meal)
            
            cell = mealCell
        }
        self.presenter.cellForRowAt(index: indexPath.row, pfcCell: makePfcCell, mealCell: makeMealCell)
        
        return cell!
         */
    }
}
