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

struct Accounts {
    var name: String?
    var sumInAccounts: Double?
}

struct AnalyticsIncomeDataForGraphic: Codable {
    var date: String
    var sumOfTransaction: Double
}

struct ArrayAnalyticsDataForGraphicIncome {
    var data: String
    var sumOfTransaction: Double
}

struct ArrayAnalyticsDataForGraphicExpense {
    var data: String
    var sumOfTransaction: Double
}

struct IncomeDataAnalytics {
    var name: String
    var sum: Double
}

struct ExpenseDataAnalytics {
    var name: String?
    var sum: Double?
}

struct IncomeAnalyticsData: Codable {
    var name: String?
    var sum: Double?
}

class Model {
    var accounts = [Accounts]()
    var transactions = [Transactions]()
    var analyticsForIncome = [IncomeDataAnalytics]()
    var analyticsForExpense = [ExpenseDataAnalytics]()
    var analyticsForIncomeGraph = [ArrayAnalyticsDataForGraphicIncome]()
    var analyticsForExpenseGraph = [ArrayAnalyticsDataForGraphicExpense]()
    let defaults = UserDefaults()
    var accountsArray = [String]()
    
    
 
    func getAnalyticsForIncomeCat(urlString: URLComponents, completed: @escaping () -> ()) {
        let token = defaults.object(forKey:"token") as? String ?? ""

        var request = URLRequest(url: urlString.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
       
       let session = URLSession.shared
       
       let task = session.dataTask(with: request) { (data, response, error) in
           if let error = error {
               print("Error: \(error)")
           }
           do {
               let result: [IncomeAnalyticsData] = try JSONDecoder().decode([IncomeAnalyticsData].self, from: data!)
               
               for index in 0..<result.count {
                let data = IncomeDataAnalytics(name: result[index].name ?? "", sum: result[index].sum ?? 0.0)
                self.analyticsForIncome.append(data)
               }
               
           } catch {
           
               print("ERROR IN GETTING Analytics For income")
           }
           completed()
           
       }
       task.resume()
           
   }
    
    func getAnalyticsForExpenseCat(urlString: URLComponents, completed: @escaping () -> ()) {
        let token = defaults.object(forKey:"token") as? String ?? ""

        var request = URLRequest(url: urlString.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
       
       let session = URLSession.shared
       
       let task = session.dataTask(with: request) { (data, response, error) in
           if let error = error {
               print("Error: \(error)")
           }
           do {
               let result: [IncomeAnalyticsData] = try JSONDecoder().decode([IncomeAnalyticsData].self, from: data!)
               
               for index in 0..<result.count {
                    print("HERE IT IS \(result[index].name)")
                let data = ExpenseDataAnalytics(name: result[index].name, sum: result[index].sum)
                self.analyticsForExpense.append(data)
               }
               
           } catch {
           
               print("ERROR IN GETTING Analytics For expense")
           }
           completed()
           
       }
       task.resume()
           
   }
    
    func getAnalyticsForIncomeGrapghic(urlString: URLComponents, completed: @escaping () -> ()) {
        let token = defaults.object(forKey:"token") as? String ?? ""

        var request = URLRequest(url: urlString.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
       
       let session = URLSession.shared
       
       let task = session.dataTask(with: request) { (data, response, error) in
           if let error = error {
               print("Error: \(error)")
           }
           do {
               let result: [AnalyticsIncomeDataForGraphic] = try JSONDecoder().decode([AnalyticsIncomeDataForGraphic].self, from: data!)
            if result.count == 1 {
                
            } else {
                for index in 0..<result.count {
                 let data = ArrayAnalyticsDataForGraphicIncome(data: result[index].date, sumOfTransaction: result[index].sumOfTransaction)
                     print("THIS IS THE DATE FOR TEST \(result[index].date)")
                     self.analyticsForIncomeGraph.append(data)
                }
            }
              
               
           } catch {
           
               print("ERROR IN GETTING Graphic For income")
           }
           completed()
           
       }
       task.resume()
           
   }
    
    func getAnalyticsForExpenseGrapghic(urlString: URLComponents, completed: @escaping () -> ()) {
        let token = defaults.object(forKey:"token") as? String ?? ""

        var request = URLRequest(url: urlString.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
       
       let session = URLSession.shared
       
       let task = session.dataTask(with: request) { (data, response, error) in
           if let error = error {
               print("Error: \(error)")
           }
           do {
               let result: [AnalyticsIncomeDataForGraphic] = try JSONDecoder().decode([AnalyticsIncomeDataForGraphic].self, from: data!)
            if result.count == 1 {
                
            } else {
                for index in 0..<result.count {
                 let data = ArrayAnalyticsDataForGraphicExpense(data: result[index].date, sumOfTransaction: result[index].sumOfTransaction)
                     self.analyticsForExpenseGraph.append(data)
                }
            }

               
               
           } catch {
           
               print("ERROR IN GETTING Graphic For expense")
           }
           completed()
           
       }
       task.resume()
           
   }
    
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
                self.accountsArray.append(resp.name ?? "")
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
    //var tags: [String]
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

struct Sums: Codable {
    var sumOfExpenses: Double
    var sumOfIncomes: Double
}


final class ExchangeData: Codable {
    var actualDate: String
    var description: String?
    var fromCashAccount: String?
    var sumOfTransaction: Double?
    var tags: String?
    var toCashAccount: String?
   
   
  

    
    init(actualDate: String, fromCashAccount: String, toCashAccount: String, tags: String?, description: String?, sumOfTransaction: Double) {
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
    var actualDate: String
    var cashAccount: String
    var type: String
    var category: String
    var project: String?
    var contractor: String?
    var description: String?
    var sumOfTransaction: Double
//    var tags: [Tags]?
}

struct Tags: Codable {
    var createdBy: String?
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



