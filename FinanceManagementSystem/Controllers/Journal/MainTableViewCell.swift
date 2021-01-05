//
//  MainTableViewCell.swift
//  FinanceManagementSystem
//
//  Created by User on 12/9/20.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageForAgent: UIImageView!
    @IBOutlet weak var agentLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageForProject: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var cashAccountLabel: UILabel!
    @IBOutlet weak var numberInCashAccountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var agentImageView: UIImageView!
    
    
    var trans: Transactions! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: trans.date )
            dateLabel.text = "\(dateString)"
            
            if trans.type == "Доход" {
                arrowImageView.isHidden = true
                dividerView.isHidden = false
                agentImageView.isHidden = false
                imageForProject.isHidden = false
                categoryLabel.text = trans.category
                numberLabel.textColor = UIColor(red: 36/255, green: 180/255, blue: 130/255, alpha: 1)
                numberLabel.text = "+ \(String(trans.sumOfTransaction))"
                categoryLabel.text = trans.category
                agentLabel.text = trans.contractor
                projectLabel.text = trans.project
                cashAccountLabel.text = trans.cashAccount
                descriptionLabel.text = trans.description1
                
            } else if trans.type == "Расход" {
                dividerView.isHidden = false
                agentImageView.isHidden = false
                imageForProject.isHidden = false
                arrowImageView.isHidden = true
                categoryLabel.text = trans.category
                numberLabel.text = "- \(String(trans.sumOfTransaction))"
                numberLabel.textColor = UIColor(red: 224/255, green: 47/255, blue: 47/255, alpha: 0.89)
                categoryLabel.text = trans.category
                agentLabel.text = trans.contractor
                projectLabel.text = trans.project
                cashAccountLabel.text = trans.cashAccount
                descriptionLabel.text = trans.description1
            } else if trans.type == "Перевод" {
                dividerView.isHidden = true
                agentImageView.isHidden = true
                imageForProject.isHidden = true
                arrowImageView.isHidden = false
                categoryLabel.text = trans.type
                agentLabel.text = trans.cashAccount
                projectLabel.text = trans.category.replacingOccurrences(of: "->", with: "", options: NSString.CompareOptions.literal, range: nil)
                numberLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.69)
                numberLabel.text = "  \(String(trans.sumOfTransaction))"
                descriptionLabel.text = trans.description1
            }
        }
    }
    
}
