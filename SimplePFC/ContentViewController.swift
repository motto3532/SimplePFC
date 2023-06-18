//
//  ContentViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/06/15.
//

import UIKit

class ContentViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbonhydrateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
    }
    
    //食事内容を受け取る変数
    var mealContents:[(Name: String, protein: Int, fat: Int, carbohydrate: Int)] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mealContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
 
        cell.textLabel?.text = mealContents[indexPath.row].Name
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.mealContents)
        tableView.reloadData()
    }
}
