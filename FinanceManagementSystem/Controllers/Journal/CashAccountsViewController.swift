//
//  CashAccountsViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/11/20.
//

import UIKit

class CashAccountsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        model.getAccounts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    
    
}

extension CashAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CashAccountTableViewCell
        
        cell.accs = model.accounts[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
