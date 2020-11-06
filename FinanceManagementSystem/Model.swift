//
//  Model.swift
//  FinanceManagementSystem
//
//  Created by User on 10/28/20.
//

import Foundation



struct Model {
    
    var transactions = [Transactions]()
 
}


struct Transactions {
    var date: String
    var account: String
    var project: String
    var type: String
    var category: String
    var contractor: String
    var description1: String
    var sumOfTransaction: Double
    var tags: [String]
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

final class ExchangeData: Codable {
    var actualDate: String
    var cashAccountFrom: String
    var cashAccountTo: String
    var description: String?
    var sumOfTransaction: Int

    
    init(actualDate: String, cashAccountFrom: String, cashAccountTo: String, description: String, sumOfTransaction: Int) {
        self.actualDate = actualDate
        self.cashAccountFrom = cashAccountFrom
        self.cashAccountTo = cashAccountTo
        self.description = description
        self.sumOfTransaction = sumOfTransaction
    }
    
}

struct ModelOfBook: Codable {
    var actualDate: String
    var cashAccount: String
    var type: String
    var category: String?
    var project: String?
    var contractor: String?
    var description: String?
    var sumOfTransaction: Double
    var tags: [Tags]
}

struct Tags: Codable {
    var name: String?
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
