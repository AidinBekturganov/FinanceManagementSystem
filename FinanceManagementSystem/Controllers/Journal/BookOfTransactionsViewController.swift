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
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        setupIndicator()
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/transactions")!
        urlString.queryItems = []
        urlString.queryItems?.append(URLQueryItem(name: "pageNumber", value: "\(page)"))
        urlString.queryItems?.append(URLQueryItem(name: "transactionsInPage", value: "20"))
        
        getData(page: page, url: urlString) {
            print("Done")
            DispatchQueue.main.async {
                self.attemptToAssembleGroupedTransactions()
                self.tableView.reloadData()
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
        
        
    }
    
    func transitionViewController() {
        
        let authPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.authViewController) as? AuthViewController
        
        view.window?.rootViewController = authPage
        view.window?.makeKeyAndVisible()
        
    }
    
    @objc private func didPullToRefresh() {
        print("REFRESHING DATA")
        page = 1
        model.transactions.removeAll()
        var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/transactions")!
        urlString.queryItems = []
        urlString.queryItems?.append(URLQueryItem(name: "pageNumber", value: "\(page)"))
        urlString.queryItems?.append(URLQueryItem(name: "transactionsInPage", value: "20"))
        
        getData(page: page, url: urlString) {
            print("Done")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.tableView.refreshControl?.endRefreshing()
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
    var typeFilterItem = "Доход"
    var page = 1
    var flag = false
    var trans = [ModelOfBook]()
    
   
     
    
    func getData(page: Int, url: URLComponents, completed: @escaping () -> ()) {
        
        let token = defaults.object(forKey:"token") as? String ?? ""
        var request = URLRequest(url: url.url!)
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
                self.trans = []
                self.number = Int(result.numberOfPages)
                self.trans = self.trans + result.transactions
                for i in 0..<self.trans.count {
                    //print("HERE IS THE TRANSACTION \(result[i].actualDate ?? "")")
                    self.date = Date.dateFromCustomString(customString: self.trans[i].actualDate ?? "")
                    self.account =
                        self.trans[i].cashAccount ?? ""
                    self.project = self.trans[i].project ?? "-"
                    self.category = self.trans[i].category ?? "-"
                    self.type = self.trans[i].type ?? ""
                    self.contractor = self.trans[i].contractor ?? "-"
                    self.description1 = self.trans[i].description ?? "-"
                    self.sumOfTransaction = self.trans[i].sumOfTransaction ?? 0
                    for index in 0..<self.trans[i].tags.count {
                        if self.trans[i].tags[index].name == "" {

                        } else {
                            let name1 = self.trans[i].tags[index].name ?? "-"
                            self.tags.append(name1)
                        }

                    }
                    let trans = Transactions(date: self.date, account: self.account, cashAccount: self.account, project: self.project, type: self.type, category: self.category, contractor: self.contractor, description1: self.description1, sumOfTransaction: self.sumOfTransaction, tags: self.tags, numberOfPages: self.number)



                    self.model.transactions.append(trans)

                }
            } catch {
                print("ERROR IN CATCHING DATA OF BOOK")
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 else {
                   
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Ошибка авторизации", message: "Пожалуйста авторизуйтесь", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                            
                            self.transitionViewController()
                            
                        }))
                        self.present(alert, animated: true)
                    }
                    return
                }
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
        flag = true
        page = 1

        var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/transactions")!
        urlString.queryItems = []

        urlString.queryItems?.append(URLQueryItem(name: "typeOfTransaction", value: typeFilterItem))

        urlString.queryItems?.append(URLQueryItem(name: "pageNumber", value: "\(page)"))
        urlString.queryItems?.append(URLQueryItem(name: "transactionsInPage", value: "20"))

        getData(page: page, url: urlString) {
            DispatchQueue.main.async {
                print("EXECUTED THIS GET IN FILTER")
                self.attemptToAssembleGroupedTransactions()
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionTableViewCell
        if flag {
            
            if indexPath.row == model.transactions.count - 1 {
               
                if model.transactions[indexPath.row].numberOfPages - page == 0 {
                    
                } else {
                    page += 1
                    var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/transactions")!
                    urlString.queryItems = []
                   
                    urlString.queryItems?.append(URLQueryItem(name: "typeOfTransaction", value: typeFilterItem))

                    urlString.queryItems?.append(URLQueryItem(name: "pageNumber", value: "\(page)"))
                    urlString.queryItems?.append(URLQueryItem(name: "transactionsInPage", value: "20"))
                    
                    getData(page: page, url: urlString) {
                        DispatchQueue.main.async {
                            print("EXECUTED THIS GET IN FILTER")
                            self.attemptToAssembleGroupedTransactions()
                            self.tableView.reloadData()
                            self.indicatorView.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            
                        }
                    }

                }
                
            }
        } else {
            if indexPath.row == model.transactions.count - 1 {
               
                if model.transactions[indexPath.row].numberOfPages - page == 0 {
                    
                } else {
                    page += 1
                    print("HERE IS THE PAGE\(page)")
                    
                    var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/transactions")!
                    urlString.queryItems = []
                    urlString.queryItems?.append(URLQueryItem(name: "pageNumber", value: "\(page)"))
                    urlString.queryItems?.append(URLQueryItem(name: "transactionsInPage", value: "20"))
                    
                    getData(page: page, url: urlString) {
                        DispatchQueue.main.async {
                            print("EXECUTED THIS GET")
                            self.attemptToAssembleGroupedTransactions()
                            self.tableView.reloadData()
                            self.indicatorView.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            
                        }
                    }
                }
                
            }
        }
        
        cell.trans = model.transactions[indexPath.row]
        return cell
    }
    
    
}
