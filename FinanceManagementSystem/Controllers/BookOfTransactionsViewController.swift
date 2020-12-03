//
//  BookOfTransactionsViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 11/1/20.
//
import Foundation
import UIKit

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "kg_KG_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

class BookOfTransactionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let todayDate = Date()
    let defaults = UserDefaults()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        setupIndicator()
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        getData(page: 1) {
            print("Done")
            DispatchQueue.main.async {
                self.attemptToAssembleGroupedTransactions()
                self.tableView.reloadData()
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
        
    
    
    }
    
    
    fileprivate func attemptToAssembleGroupedTransactions() {
        let gropedTrans = Dictionary(grouping: model.transactions, by: { (element) -> Date in
            return element.date
        })
        
        let sortedKeys = gropedTrans.keys.sorted(by: >)
        sortedKeys.forEach { (key) in
            let values = gropedTrans[key]
            transactionsArray.append(values ?? [])
        }
        
    }
    var date: Date = Date()
    var account: String = ""
    var category: String = ""
    var contractor: String = ""
    var description1: String = ""
    var sumOfTransaction: Double = 0
    var type: String = ""
    var project = ""
    var number = 0
    var tags: [String] = []
    var transactionsArray = [[Transactions]]()
    
    
    var model = Model()
    var indicatorView = UIActivityIndicatorView()

    func setupIndicator() {
        indicatorView.center = self.view.center
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = UIColor.green
        view.addSubview(indicatorView)
    }
    var r = "Демир"
    var a = ""
    var page = 1
    var trans = [ModelOfBook]()
    
    func getData(page: Int, completed: @escaping () -> ()) {
       // let new = r.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let urlString = "https://fms-neobis.herokuapp.com/transactions?pageNumber=\(page)&transactionsInPage=20"
//        var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/transactions")!
//        urlString.queryItems = []
//        if a == "" {
//
//        } else {
//            urlString.queryItems?.append(URLQueryItem(name: "contractor", value: a))
//
//        }
//
//        urlString.queryItems?.append(URLQueryItem(name: "pageNumber", value: "1"))
//        urlString.queryItems?.append(URLQueryItem(name: "transactionsInPage", value: "10"))
        
//        urlString.queryItems = [
//            URLQueryItem(name: "cashAccount", value: "Демир"),
//            URLQueryItem(name: "pageNumber", value: "1"),
//            URLQueryItem(name: "transactionsInPage", value: "10")
//        ]
        
        guard let url = URL(string: urlString) else {
            completed()
            return
        }
        
        let token = defaults.object(forKey:"token") as? String ?? ""
        var request = URLRequest(url: url)
        //print(urlString.url!)

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }
            
            do {
                let result = try JSONDecoder().decode(ModelsOfBook.self, from: data ?? Data())
                print(result)
                self.number = Int(result.numberOfPages)
                self.trans = self.trans + result.transactions
                for i in 0..<self.trans.count {
                    //print("HERE IS THE TRANSACTION \(result[i].actualDate ?? "")")
                    self.date = Date.dateFromCustomString(customString: result.transactions[i].actualDate ?? "")
                    self.account =
                        result.transactions[i].cashAccount ?? ""
                    self.project = result.transactions[i].project ?? "-"
                    self.category = result.transactions[i].category ?? "-"
                    self.type = result.transactions[i].type ?? ""
                    self.contractor = result.transactions[i].contractor ?? "-"
                    self.description1 = result.transactions[i].description ?? "-"
                    self.sumOfTransaction = result.transactions[i].sumOfTransaction ?? 0
                    for index in 0..<result.transactions[i].tags.count {
                        if result.transactions[i].tags[index].name == "" {

                        } else {
                            let name1 = result.transactions[i].tags[index].name ?? "-"
                            self.tags.append(name1)
                        }

                    }
                    let trans = Transactions(date: self.date, account: self.account, cashAccount: self.account, project: self.project, type: self.type, category: self.category, contractor: self.contractor, description1: self.description1, sumOfTransaction: self.sumOfTransaction, tags: self.tags, numberOfPages: self.number)



                    self.model.transactions.append(trans)

                }
            } catch {
                print("ERROR IN CATCHING DATA OF BOOK")
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
        transactionsArray = []
        model.transactions = []
        tableView.reloadData()
        setupIndicator()
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
//        getData(page: page) {
//            DispatchQueue.main.async {
//                self.attemptToAssembleGroupedTransactions()
//                self.tableView.reloadData()
//                self.indicatorView.stopAnimating()
//                self.view.isUserInteractionEnabled = true
//            }
//        }
    }
    
}


extension BookOfTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return transactionsArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
//        let label = UILabel()
//        label.frame = CGRect(x: 17, y: 5, width: 144, height: 35)
//        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
//        label.font = UIFont(name: "Roboto-Medium", size: 22)
//        view.addSubview(label)
//        if let firstMessageInSection = transactionsArray[section].first {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            let dateString = dateFormatter.string(from: firstMessageInSection.date)
//            let todayDateString = dateFormatter.string(from: todayDate)
//            
//            
//            
//            if dateString == todayDateString {
//             
//                label.text = "Сегодня"
//
//            } else {
//                    label.text = dateString
//            }
//        }
//        
//       
//      return view
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        50
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.transactions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionTableViewCell
        print(indexPath.row, model.transactions.count - 1)
        if indexPath.row == model.transactions.count - 1 {
            page += 1
            getData(page: page) {
                DispatchQueue.main.async {
                    print("EXECUTED THIS GET")
                    self.attemptToAssembleGroupedTransactions()
                    self.tableView.reloadData()
                    self.indicatorView.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
            
            
        }
        cell.trans = model.transactions[indexPath.row]
        return cell
    }
    
    
}
