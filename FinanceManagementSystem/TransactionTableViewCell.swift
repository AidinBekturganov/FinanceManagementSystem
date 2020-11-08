//
//  TransactionTableViewCell.swift
//  FinanceManagementSystem
//
//  Created by User on 11/5/20.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var summLabel: UILabel!
    
    var trans: Transactions! {
        didSet {
            dateLabel.text = trans.date
            categoryLabel.text = trans.category
            if trans.type == "Доход" {
                summLabel.textColor = .green
                summLabel.text = "+ \(String(trans.sumOfTransaction))"
            } else if trans.type == "Расход" {
                summLabel.text = "- \(String(trans.sumOfTransaction))"
                summLabel.textColor = .red
            } else if trans.type == "Перевод" {
                summLabel.textColor = .black
                summLabel.text = "  \(String(trans.sumOfTransaction))"
            }
        }
    }
}
