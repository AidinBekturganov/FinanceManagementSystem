//
//  Model.swift
//  FinanceManagementSystem
//
//  Created by User on 10/28/20.
//

import Foundation

struct Sum: Codable {
    var sum: Double
}

class Model {
    var accounts = [Accounts]()
    var transactions = [Transactions]()
    let defaults = UserDefaults()
    var accountsArray = [String]()
    
 
    func getAccounts(completed: @escaping () -> ()) {
       let urlString = "https://fms-neobis.herokuapp.com/cash_accounts/not_archived"
        let token = defaults.object(forKey:"token") as? String ?? ""
       guard let url = URL(string: urlString) else {
           completed()
           return
       }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
       
       let session = URLSession.shared
       
       let task = session.dataTask(with: request) { (data, response, error) in
           if let error = error {
               print("Error: \(error)")
           }
           do {
               let result: [CashAccounts] = try JSONDecoder().decode([CashAccounts].self, from: data!)
               
               for index in 0..<result.count {
                   let resp = Accounts(name: result[index].name ?? "", sumInAccounts: result[index].sumInAccount ?? 0)
                self.accountsArray.append(resp.name)
                self.accounts.append(resp)
               
               }
               
           } catch {
           
               print("ERROR IN GETTING CASH ACCOUNTS")
           }
           completed()
           
       }
       task.resume()
           
   }
    
    func getSum(completed: @escaping () -> ()) {
       let urlString = "https://fms-neobis.herokuapp.com/expenses"

       guard let url = URL(string: urlString) else {
           completed()
           return
       }
        let token = defaults.object(forKey:"token") as? String ?? ""
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
       let session = URLSession.shared
       
       let task = session.dataTask(with: request) { (data, response, error) in
           if let error = error {
               print("Error: \(error)")
           }
           do {
                print("Done\(data)")
                let result = try JSONDecoder().decode(Sum.self, from: data!)
                print(result)
              
               
           } catch {
           
               print("ERROR IN GETTING CASH ACCOUNTS")
           }
           completed()
           
       }
       task.resume()
           
    }
    
}


struct Transactions {
    var date: Date
    var account: String
    var cashAccount: String
    var project: String
    var type: String
    var category: String
    var contractor: String
    var description1: String
    var sumOfTransaction: Double
    var tags: [String]
    var numberOfPages: Int
}

//final class IncomeData: Codable {
//    var actualDate: String?
//    var cashAccount: String?
//    var category: String?
//    var status: Bool
//    var sumOfTransaction: Int?
//    
//    init(actualDate: String, cashAccount: String, category: String, status: Bool, sumOfTransaction: Int) {
//        self.actualDate = actualDate
//        self.cashAccount = cashAccount
//        self.category = category
//        self.status = status
//        self.sumOfTransaction = sumOfTransaction
//    }
//    
//}


final class IncomeData: Codable {
    var actualDate: String?
    var cashAccount: String?
    var category: String?
    var contractor: String?
    var description: String?
    var status: Bool
    var project: String?
    var sumOfTransaction: Int?
    var tags: String?

    init(actualDate: String, cashAccount: String, category: String, contractor: String?, description: String?, status: Bool, project: String?, sumOfTransaction: Int, tags: String?) {
        self.actualDate = actualDate
        self.cashAccount = cashAccount
        self.category = category
        self.contractor = contractor
        self.description = description
        self.status = status
        self.project = project
        self.sumOfTransaction = sumOfTransaction
        self.tags = tags
    }

}

final class CreatCashAccount: Codable {

    var name: String?
    
    init(name: String) {
        self.name = name
    }
    
}

final class ExchangeData: Codable {
    var actualDate: String
    var description: String?
    var fromCashAccount: String?
    var sumOfTransaction: Double?
    var tags: String?
    var toCashAccount: String?
   
   
  

    
    init(actualDate: String, fromCashAccount: String, toCashAccount: String, tags: String, description: String, sumOfTransaction: Double) {
        self.actualDate = actualDate
        self.tags = tags
        self.fromCashAccount = fromCashAccount
        self.toCashAccount = toCashAccount
        self.description = description
        self.sumOfTransaction = sumOfTransaction
    }
    
}


struct ModelsOfBook: Codable {
    var numberOfPages: Int
    var transactions: [ModelOfBook]
}


struct ModelOfBook: Codable {
    var actualDate: String?
    var cashAccount: String?
    var type: String?
    var category: String?
    var project: String?
    var contractor: String?
    var description: String?
    var sumOfTransaction: Double?
    var tags: [Tags]
}

struct Tags: Codable {
    var name: String?
}

struct Agents: Codable {
    var name: String?
}

struct CashAccounts: Codable {
    var name: String?
    var sumInAccount: Double?
}

struct IncomeCategories: Codable {
    var categoryName: String?
}

struct Categories: Codable {
    var name: String?
}



