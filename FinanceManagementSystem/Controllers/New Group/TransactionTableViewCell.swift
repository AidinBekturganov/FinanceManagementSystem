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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: trans.date )
            dateLabel.text = "\(dateString)"
            categoryLabel.text = trans.category
            if trans.type == "Доход" {
                summLabel.textColor = UIColor(red: 36/255, green: 180/255, blue: 130/255, alpha: 1)
                summLabel.text = "+ \(String(trans.sumOfTransaction))"
            } else if trans.type == "Расход" {
                summLabel.text = "- \(String(trans.sumOfTransaction))"
                summLabel.textColor = UIColor(red: 224/255, green: 47/255, blue: 47/255, alpha: 0.89)
            } else if trans.type == "Перевод" {
                summLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.69)
                summLabel.text = "  \(String(trans.sumOfTransaction))"
            }
        }
    }
}
