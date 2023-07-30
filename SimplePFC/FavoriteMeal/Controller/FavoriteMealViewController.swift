//
//  FavoriteMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/30.
//

import UIKit

/*
 ・セルに表示するのは食材名だけ
 ・スライドでお気に入りから削除
 ・タップでAddMeal画面に移動
 ・お気に入り食材を複数まとめて選択してAddMeal画面に移動(編集モード的なの想像してたけど、セルのタップイベントと競合しそう <- 編集モードの時はタップイベントオフにすればいいか)
 ・お気に入り食材同士を合成してお気に入り登録(合成ボタンでも追加するか)
 ・お気に入り食材をAddMeal画面で編集できるようにする（datePicker.isHiddenで隠せばいけるかな？）
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
    }
}

extension FavoriteMealViewController: FavoriteMealPresenterProtocolOutput {
    func showMeal(favoriteMeal: FavoriteMealModel) {
        Router.shared.showMeal(from: self, favoriteMeal: favoriteMeal)
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}

extension FavoriteMealViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelect(index: indexPath.row)
    }
}

extension FavoriteMealViewController: UITableViewDataSource {
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