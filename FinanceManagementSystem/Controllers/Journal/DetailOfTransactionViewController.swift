//
//  DetailOfTransactionViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 11/6/20.
//

import UIKit

class DetailOfTransactionViewController: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var summLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var agentLabel: UILabel!
    @IBOutlet weak var cashAccountLabel: UILabel!
    @IBOutlet weak var descriptionLAbel: UITextView!
    
    
    
    var item: Transactions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()
        
    }
    
    
    func updateUserInterface() {
        print(item.date)
        dateLabel.text = "\(item.date)"
        cashAccountLabel.text = item.account
        categoryLabel.text = "Категория: \(item.category)"
        projectLabel.text = "Проект: \(item.project)"
        summLabel.text = "Сумма: \(String(item.sumOfTransaction))"
        // tagLabel.text = "Тэг: \(item.tags.joined(separator: ", "))"
        typeLabel.text = "Тип: \(item.type)"
        agentLabel.text = "Контрагент: \(item.contractor)"
        descriptionLAbel.text = "Комментарий: \(item.description1)"
        
        // print(item.tags.joined(separator: ", "))
    }
    
    
}
