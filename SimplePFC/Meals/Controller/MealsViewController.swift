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
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    //init()で初期化するわけじゃないからvarで宣言
    private var presenter: MealsPresenterInput!
                                                                                                
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //次の画面のbackボタンを戻るに変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        
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
    var pfcCellHeight: CGFloat {
        PFCTableViewCell.cellHeight
    }
    
    var mealCellHeight: CGFloat {
        MealTableViewCell.cellHeight
    }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    func showAddMeal(meal: MealModel?, date: Date?) {
        //新規->meal:nil, date:ある
        //編集->meal:ある, date:nil
        Router.shared.showAddMeal(from: self, meal: meal, date: date)
    }
    
    func showFavoriteMeal(date: Date) {
        Router.shared.showFavoriteMeals(from: self, date: date)
    }
}

extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.presenter.heightForRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.presenter.didSelect(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .lightGray
        view.setCornerRadius(cornerRadius: 5)
        guard let header = view as? UITableViewHeaderFooterView else {
            fatalError()
        }
        header.textLabel?.textColor = .black
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        var editingStyle = UITableViewCell.EditingStyle.delete
        
        let isPFCCell = {() -> Void in
            editingStyle = UITableViewCell.EditingStyle.none
        }
        self.presenter.editingStyleForRowAt(indexPath: indexPath, isPFCCell: isPFCCell)
        
        return editingStyle
    }
}

extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let deleteRow = {() -> Void in
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let deleteSection = {() -> Void in
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        self.presenter.deleteMeal(indexPath: indexPath, deleteRow: deleteRow, deleteSection: deleteSection)
    }
    
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
        var cell: UITableViewCell?
        
        let pfcCell = {(meals: [MealModel], date: Date) -> Void in
            guard let pfcCell = tableView.dequeueReusableCell(withIdentifier: PFCTableViewCell.className) as? PFCTableViewCell else {
                fatalError()
            }
            pfcCell.configure(meals: meals, date: date)
            cell = pfcCell
        }
        
        let mealCell = {(meal: MealModel) -> Void in
            guard let mealCell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.className) as? MealTableViewCell else {
                fatalError()
            }
            mealCell.configure(meal: meal)
            cell = mealCell
        }
        
        self.presenter.cellForRowAt(indexPath: indexPath, pfcCell: pfcCell, mealCell: mealCell)
        
        guard let _cell = cell else { fatalError() }
        return _cell
    }
}
