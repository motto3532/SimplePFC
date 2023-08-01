//
//  FavoriteMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/30.
//

import UIKit

/*
 ・お気に入り食材を複数まとめて選択してAddMeal画面に移動(編集モード的なの想像してたけど、セルのタップイベントと競合しそう <- 編集モードの時はタップイベントオフにすればいいか)
 ↑viewでcellForRowメソッドを用意してそこでselectとdeselectを判別してチェックマークの画像を表示する（もしくはチェック状態を管理するUIパーツを配置）
 ・お気に入り食材同士を合成してお気に入り登録(合成ボタンでも追加するか)
 */
final class FavoriteMealViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: FavoriteMealTableViewCell.className, bundle: nil), forCellReuseIdentifier: FavoriteMealTableViewCell.className)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .white
        }
    }
    
    private var presenter: FavoriteMealPresenterProtocolInput!
    
    func inject(presenter: FavoriteMealPresenterProtocolInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.reloadData()
        
        //複数選択ボタン
        let multipleSelectionBarButton = UIBarButtonItem(title: "複数選択", style: .plain, target: self, action: #selector(multipleSelectionBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = multipleSelectionBarButton
    }
}

@objc private extension FavoriteMealViewController {
    func multipleSelectionBarButtonTapped(_ sender: UIResponder) {
        self.tableView.allowsMultipleSelection = true
        
        let decisionBarButton = UIBarButtonItem(title: "決定", style: .plain, target: self, action: #selector(decisionBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = decisionBarButton
    }
    
    func decisionBarButtonTapped(_ sender: UIResponder) {
        Router.shared.goBack(from: self, favoriteMeals: self.presenter.selectedFavoriteMeals())
    }
}

extension FavoriteMealViewController: FavoriteMealPresenterProtocolOutput {
    
    func goBack(favoriteMeal: FavoriteMealModel) {
        Router.shared.goBack(from: self, favoriteMeal: favoriteMeal)
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}

extension FavoriteMealViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         複数選択モードなら.checkmark採用、違うならタップでAddMeal画面に行きたい
         でも下の記述だと分岐処理書いてるからMVPじゃないね
         */
        if self.tableView.allowsMultipleSelection {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            self.presenter.didSelect(index: indexPath.row, isChecked: true)
        } else {
            self.presenter.didSelect(index: indexPath.row, isChecked: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        self.presenter.didDeselect(index: indexPath.row)
    }
}

extension FavoriteMealViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.presenter.deleteFavoriteMeal(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numOfFavoriteMeals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMealTableViewCell.className) as? FavoriteMealTableViewCell else {
            fatalError()
        }
        cell.configure(favoriteMeal: self.presenter.getFavoriteMeal(index: indexPath.row))
        return cell
    }
}
