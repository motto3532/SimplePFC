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
        
        //追加ボタン
        let addMealBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMealBarButtonItemTapped(_:)))
        
        //お気に入りボタン
        let favoriteMealBarButton: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(favoriteMealBarButtonItemTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [addMealBarButton, favoriteMealBarButton]
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
    
    func favoriteMealBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.presenter.favoriteMealBarButtonItemTapped()
    }
}

extension MealsViewController: MealsPresenterOutput {
    
    func reload() {
        self.tableView.reloadData()
    }
    
    func showAddMeal(meal: MealModel?) {
        Router.shared.showAddMeal(from: self, meal: meal)
    }
    
    func showFavoriteMeal() {
        Router.shared.showFavoriteMeals(from: self)
    }
}

extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.presenter.cellHeight(section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.presenter.didSelect(section: indexPath.section, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .lightGray
        guard let header = view as? UITableViewHeaderFooterView else {
            fatalError()
        }
        header.textLabel?.textColor = .black
    }
}

extension MealsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.presenter.titleForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let pfcCell = self.tableView.dequeueReusableCell(withIdentifier: PFCTableViewCell.className) as? PFCTableViewCell else {
                fatalError()
            }
            pfcCell.configure(meals: self.presenter.getMeals(), date: self.presenter.getDate())
            return pfcCell
        }
        
        guard let mealCell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.className) as? MealTableViewCell else {
            fatalError()
        }
        mealCell.configure(meal: self.presenter.getMeal(section: indexPath.section, row: indexPath.row))
        return mealCell
    }
}
