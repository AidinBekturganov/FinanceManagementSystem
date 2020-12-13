//
//  CashAccountsViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/11/20.
//

import UIKit

struct SumInCash: Codable {
    var sumInCashAccounts: Double?
}

class CashAccountsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sumInCashAccounts: UILabel!
    
    let model = Model()
    var defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        model.getAccounts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        getCashAccointsSum {
            DispatchQueue.main.async {
                self.sumInCashAccounts.text = "\(String(self.sum)) сом"
            }
        }
        
    }
    
    var sum = 0.0
    
    func getCashAccointsSum(completed: @escaping () -> ()) {
       let urlString = "https://fms-neobis.herokuapp.com/sum_in_cash_accounts"
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
               let result = try JSONDecoder().decode(SumInCash.self, from: data!)
            self.sum = result.sumInCashAccounts ?? 0.0
               
           } catch {
               guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 else {
                  
                   DispatchQueue.main.async {
                       let alert = UIAlertController(title: "Ошибка авторизации", message: "Пожалуйста авторизуйтесь", preferredStyle: .alert)
                       
                       alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                           
                           //self.transitionViewController()
                           
                       }))
                       self.present(alert, animated: true)
                   }
                   return
               }
               print("ERROR")
           }
           completed()
           
       }
       task.resume()
           
   }
    
    
    
}

extension CashAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CashAccountTableViewCell
        
        cell.accs = model.accounts[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
