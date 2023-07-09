//
//  MealsViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/08.
//

import UIKit

final class MealsViewController: UIViewController {
    
    @IBOutlet weak var addMealButton: UIButton! {
        didSet {
            addMealButton.addTarget(self, action: #selector(tapAddMealButton(_sender:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            let showPFCViewNib = UINib(nibName: "showPFCView", bundle: nil)
            if let showPFCView = showPFCViewNib.instantiate(withOwner: nil).first as? UIView {
                containerView.addSubview(showPFCView)
            }
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
//            tableView.delegate = self
//            tableView.dataSource = self
            tableView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func tapAddMealButton(_sender: UIResponder) {
        Router.shared.showAddMeal(from: self)
    }
}

//extension MealsViewController: UITableViewDelegate {
//
//}
//
//extension MealsViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//}

