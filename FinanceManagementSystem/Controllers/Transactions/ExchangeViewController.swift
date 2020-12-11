//
//  ExchangeViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 10/27/20.
//

import UIKit
import iOSDropDown


class CellClassForExchange: UITableViewCell {
    
}

class ExchangeViewController: UIViewController {

    @IBOutlet weak var summTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var changeFromButton: DropDown!
    @IBOutlet weak var changeToButton: DropDown!
    
    let transparetView = UIView()
    let tableView = UITableView()
    var indicatorView = UIActivityIndicatorView()

    var dataSource = [String]()
    let date = Date()
    var selectedButton = UIButton()
    let defaults = UserDefaults()
    
    var accounts = [Accounts]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClassForExchange.self, forCellReuseIdentifier: "Cell")
        
        setupIndicator()
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        getAccounts {
            print("sa")
            DispatchQueue.main.async {
                self.createDropDownButtons()
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }

        
        datePicker.datePickerMode = .date
        
        }
    
    func setupIndicator() {
        indicatorView.center = self.view.center
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = UIColor.green
        view.addSubview(indicatorView)
        
        summTextField.layer.cornerRadius = 8
        changeFromButton.layer.cornerRadius = 8
        changeToButton.layer.cornerRadius = 8
        commentTextField.layer.cornerRadius = 8

    }
    
    func transitionViewController() {
        
        let authPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.authViewController) as? AuthViewController
        
        view.window?.rootViewController = authPage
        view.window?.makeKeyAndVisible()
        
    }
    
    func createDropDownButtons() {
        var acounts = [String]()
        for i in 0..<accounts.count {
            acounts.append(accounts[i].name)
        }
        
        changeToButton.optionArray = acounts
        changeFromButton.optionArray = acounts
        
        changeToButton.checkMarkEnabled = false
        changeFromButton.checkMarkEnabled = false
        changeToButton.selectedRowColor = .black
        changeFromButton.selectedRowColor = .black
        
    }
    
    
     func getAccounts(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/cash_accounts/not_archived"
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
                let result: [CashAccounts] = try JSONDecoder().decode([CashAccounts].self, from: data!)
                
                for index in 0..<result.count {
                    let resp = Accounts(name: result[index].name ?? "", sumInAccounts: result[index].sumInAccount ?? 0)
                   
                    self.accounts.append(resp)
                
                }
                
            } catch {
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
                print("ERROR")
            }
            completed()
            
        }
        task.resume()
            
    }
    
    
    
    func addTransperenty(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparetView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparetView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparetView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tappGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransperenteView))
        transparetView.addGestureRecognizer(tappGesture)
        transparetView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparetView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransperenteView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparetView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }

    @IBAction func addBarButtonPressed(_ sender: Any) {
        if summTextField != nil {
            setupIndicator()
            indicatorView.startAnimating()
            self.view.isUserInteractionEnabled = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            //let exchange = ExchangeData(actualDate: "07-11-2020", fromCashAccount: "Demir", toCashAccount: "Демир", tags: "", description: "", sumOfTransaction: 1)
            let exchange = ExchangeData(actualDate: dateFormatter.string(from: datePicker.date), fromCashAccount: changeFromButton.text ?? "", toCashAccount: changeToButton.text ?? "", tags: "", description: commentTextField.text, sumOfTransaction: Double(summTextField.text ?? "") ?? 0.0)
            
            let postRequest = APIRequest(endpoint: "transfer_transaction")
            postRequest.saveExchange(exchange, completion: { result in

                switch result {
                case .success(let message):

                    print("SUCCCESS \(message.message)")
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        let alert = UIAlertController(title: "Вывод", message: message.message, preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in

                                self.navigationController?.popViewController(animated: true)

                        }))
                        self.present(alert, animated: true)

                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте отправить запрос позже или обратитесь администратору", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true)
                    }
                    print("ERROR: \(error)")
                }



            })
            
            
        } else {
            let alert = UIAlertController(title: "Не заполнены обязательные поля", message: "Пожалуйста заполните поля зеленого цвета", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))

            self.present(alert, animated: true)
            changeFromButton.text = ""
            changeToButton.text = ""
            summTextField.text = ""
            commentTextField.text = ""
        }
    }
    
    @IBAction func clearBarButtonPressed(_ sender: Any) {
        changeFromButton.text = ""
        changeToButton.text = ""
        summTextField.text = ""
        commentTextField.text = ""
    }
    
}


extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransperenteView()
    }
    
    
}
