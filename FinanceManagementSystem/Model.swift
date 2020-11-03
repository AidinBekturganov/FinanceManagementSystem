//
//  Model.swift
//  FinanceManagementSystem
//
//  Created by User on 10/28/20.
//

import Foundation



struct Model {
    

 
}


final class IncomeData: Codable {
    var actualDate: String
    var cashAccount: String
    var category: String
    var contractor: String?
    var description: String?
    var status: Bool
    var sumOfTransaction: Int
    var tags: String?
    
    init(actualDate: String, cashAccount: String, category: String, contractor: String, description: String, status: Bool, sumOfTransaction: Int, tags: String) {
        self.actualDate = actualDate
        self.cashAccount = cashAccount
        self.category = category
        self.contractor = contractor
        self.description = description
        self.status = status
        self.sumOfTransaction = sumOfTransaction
        self.tags = tags
    }
    
}

struct ModelOfBook: Codable {
    var actualDate: String
    var cashAccount: String
    var category: String
    var contractor: String
    var description: String
    var sumOfTransaction: Int
    var tags: [Tags]
}

struct Tags: Codable {
    var name: String
}

struct Agents: Codable {
    var name: String
}

struct CashAccounts: Codable {
    var name: String
    var sumInAccount: Double
}

struct IncomeCategories: Codable {
    var categoryName: String
}

struct Categories: Codable {
    var name: String
}
