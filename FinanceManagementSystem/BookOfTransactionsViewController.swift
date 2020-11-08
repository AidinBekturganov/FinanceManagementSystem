//
//  BookOfTransactionsViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 11/1/20.
//

import UIKit

class BookOfTransactionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupIndicator()
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        getData {
            print("Done")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
        
    }
    
    var date: String = ""
    var account: String = ""
    var category: String = ""
    var contractor: String = ""
    var description1: String = ""
    var sumOfTransaction: Double = 0
    var type: String = ""
    var project = ""
    var tags: [String] = []
    
    
    var model = Model()
    var indicatorView = UIActivityIndicatorView()

    func setupIndicator() {
        indicatorView.center = self.view.center
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = UIColor.green
        view.addSubview(indicatorView)
    }
    
    func getData(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/transactions"
        
        guard let url = URL(string: urlString) else {
            completed()
            return
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }
            
            do {
                let result: [ModelOfBook] = try JSONDecoder().decode([ModelOfBook].self, from: data ?? Data())
                
                for i in 0..<result.count {
                    self.date = result[i].actualDate
                    self.account =
                        result[i].cashAccount
                    self.project = result[i].project ?? "-"
                    self.category = result[i].category ?? "-"
                    self.type = result[i].type
                    self.contractor = result[i].contractor ?? "-"
                    self.description1 = result[i].description ?? "-"
                    self.sumOfTransaction = result[i].sumOfTransaction
                    for index in 0..<result[i].tags.count {
                        if result[i].tags[index].name == "" {
                            
                        } else {
                            let name1 = result[i].tags[index].name ?? "-"
                            self.tags.append(name1)
                        }
                        
                    }
                    let trans = Transactions(date: self.date, account: self.account, cashAccount: self.account, project: self.project, type: self.type, category: self.category, contractor: self.contractor, description1: self.description1, sumOfTransaction: self.sumOfTransaction, tags: self.tags)
                    self.model.transactions.append(trans)
                }
                
            
                
            } catch {
                print("ERROR")
            }
            completed()
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailOfTransactionViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.item = model.transactions[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

    @IBAction func updateBarButtonPressed(_ sender: Any) {
        model.transactions = []
        tableView.reloadData()
        setupIndicator()
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
}


extension BookOfTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.transactions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionTableViewCell
        cell.trans = model.transactions[indexPath.row]
        return cell
    }
    
    
}
