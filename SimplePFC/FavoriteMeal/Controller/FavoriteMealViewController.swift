//
//  FavoriteMealViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/30.
//

import UIKit

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
        //次の画面のbackボタンを戻るに変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        
        //画面タイトル
        let titleLabel = UILabel()
        titleLabel.textColor = .systemMint
        titleLabel.backgroundColor = .clear
        titleLabel.text = "お気に入り食品"
        self.navigationItem.titleView = titleLabel
        
        //複数選択ボタン
        let multipleSelectionButton = UIButton(type: .system)
        multipleSelectionButton.frame.size.width = 70
        multipleSelectionButton.frame.size.height = 40
        multipleSelectionButton.setTitle("複数選択", for: .normal)
        multipleSelectionButton.setTitleColor(.systemMint, for: .normal)
        multipleSelectionButton.layer.borderColor = UIColor.systemMint.cgColor
        multipleSelectionButton.layer.borderWidth = 1
        multipleSelectionButton.layer.cornerRadius = 10
        multipleSelectionButton.addTarget(self, action: #selector(multipleSelectionButtonTapped(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: multipleSelectionButton)
        
        self.presenter.reloadData()
    }
}

@objc private extension FavoriteMealViewController {
    func multipleSelectionButtonTapped(_ sender: UIResponder) {
        self.tableView.allowsMultipleSelection = true
        
        //決定ボタン
        let decisionButton = UIButton(type: .system)
        decisionButton.frame.size.width = 70
        decisionButton.frame.size.height = 40
        decisionButton.setTitle("決定", for: .normal)
        decisionButton.setTitleColor(.white, for: .normal)
        decisionButton.backgroundColor = .systemMint
        decisionButton.addTarget(self, action: #selector(decisionButtonTapped(_:)), for: .touchUpInside)
        decisionButton.setCornerRadius(cornerRadius: 10)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: decisionButton)
    }
    
    func decisionButtonTapped(_ sender: UIResponder) {
        self.presenter.decisionBarButtonTapped()
    }
}

extension FavoriteMealViewController: FavoriteMealPresenterProtocolOutput {
    
    func showAddMeal(favoriteMeal: FavoriteMealModel?, favoriteMeals: [FavoriteMealModel]?, date: Date) {
        Router.shared.showAddMeal(from: self, favoriteMeal: favoriteMeal, favoriteMeals: favoriteMeals, date: date)
    }
    
    func emptyAlert() {
        let alert = UIAlertController(title: "食品が選択されていません", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension FavoriteMealViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let checkCell = { () -> Void in
            guard let cell = tableView.cellForRow(at: indexPath) as? FavoriteMealTableViewCell else { return }
            cell.isChecked()
        }
        
        let deselectCell = { () -> Void in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        self.presenter.didSelect(index: indexPath.row, allowsMultipleSelection: tableView.allowsMultipleSelection, checkCell: checkCell, deselectCell: deselectCell)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FavoriteMealTableViewCell else { return }
        cell.isUnchecked()
        self.presenter.didDeselect(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavoriteMealTableViewCell.cellHeight
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
