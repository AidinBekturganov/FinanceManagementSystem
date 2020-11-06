//
//  TransactionTableViewCell.swift
//  FinanceManagementSystem
//
//  Created by User on 11/5/20.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var summLabel: UILabel!
    
    var trans: Transactions! {
        didSet {
            dateLabel.text = trans.date
            typeLabel.text = trans.type
            summLabel.text = String(trans.sumOfTransaction)
        }
    }
}
