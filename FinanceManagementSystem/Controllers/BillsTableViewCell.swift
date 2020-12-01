//
//  BillsTableViewCell.swift
//  FinanceManagementSystem
//
//  Created by User on 11/21/20.
//

import UIKit

class BillsTableViewCell: UITableViewCell {

    @IBOutlet weak var billLalbe: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
    var accs: Accounts! {
        didSet {
            billLalbe.text = accs.name
            sumLabel.text = "\(String(describing: accs.sumInAccounts))"
        }
    }
    
}
