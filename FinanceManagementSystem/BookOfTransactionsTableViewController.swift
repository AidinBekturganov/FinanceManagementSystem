//
//  BookOfTransactionsTableViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 11/1/20.
//

import UIKit

class BookOfTransactionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
