//
//  CashAccountTableViewCell.swift
//  FinanceManagementSystem
//
//  Created by User on 12/11/20.
//

import UIKit

class CashAccountTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cashAccountLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    
    var accs: Accounts! {
        didSet {
            view.layer.borderWidth = 1
            view.layer.borderColor = CGColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
            view.layer.cornerRadius = 8
            cashAccountLabel.text = accs.name ?? ""
            sumLabel.text = "\(String(describing: accs.sumInAccounts ?? 0.0)) сом"
        }
    }
    
}
