//
//  AddExpenditureViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 10/27/20.
//

import UIKit
import iOSDropDown



class CellClassForExpenditure: UITableViewCell {
    
}

class AddExpenditureViewController: ViewController {

    
    @IBOutlet weak var summTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tagTextFied: UITextField!
    @IBOutlet weak var chooseTheCatButton: DropDown!
    @IBOutlet weak var chooseBillButton: DropDown!
    @IBOutlet weak var chooseAgentButton: DropDown!
    @IBOutlet weak var chooseProjectButton: DropDown!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let transparetView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    let date = Date()
    var namesOfAgents = [String]()
    var incomeCategories = [String]()
    var categories = [String]()

    var accounts = [Accounts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")

        
        getProjects {
        }
        
        getAccounts {
            print("sa")
        }
        
        
      
        getCategory {
            print("DONE")
            self.getAgents {
                print("Ready")
                self.createDropDownButtons()
            }
            
            
        }
    
        
        datePicker.datePickerMode = .date
        
    }
    
    
     func getAccounts(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/cash_accounts"
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
                let result: [CashAccounts] = try JSONDecoder().decode([CashAccounts].self, from: data!)
                
                for index in 0..<result.count {
                    let resp = Accounts(name: result[index].name, sumInAccounts: result[index].sumInAccount)
                   
                    self.accounts.append(resp)
                
                }
                
            } catch {
            
                print("ERROR")
            }
            completed()
            
        }
        task.resume()
            
    }
    
     func getAgents(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/contractors"
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
                let result: [Agents] = try JSONDecoder().decode([Agents].self, from: data!)
                print(result)
                for index in 0..<result.count {
                    self.namesOfAgents.append(result[index].name)
                }
            } catch {
                
                print("ERROR")
            }
            completed()
            
        }
        task.resume()
            
    }
    
     func getCategory(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/expenses_categories"
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
                let result: [IncomeCategories] = try JSONDecoder().decode([IncomeCategories].self, from: data!)
                print(result)
                for index in 0..<result.count {
                    print(result[index].categoryName)
                    self.incomeCategories.append(result[index].categoryName)
                }
            } catch {
                
                print("ERROR")
            }
            completed()
            
        }
        task.resume()
            
    }
    
     func getProjects(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/projects"
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
                let result: [Categories] = try JSONDecoder().decode([Categories].self, from: data!)
                print(result)
                for index in 0..<result.count {
                    print(result[index].name)
                    self.categories.append(result[index].name)
                }
            } catch {
                
                print("ERROR")
            }
            completed()
            
        }
        task.resume()
            
    }
    
  
    func createDropDownButtons() {
        var acounts = [String]()
        for i in 0..<accounts.count {
            acounts.append(accounts[i].name)
        }
        chooseAgentButton.optionArray = namesOfAgents
        chooseTheCatButton.optionArray = incomeCategories
        chooseBillButton.optionArray = acounts
        chooseProjectButton.optionArray = categories
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
    
    
    @IBAction func clearBarButtonClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func addBarButtonPressed(_ sender: Any) {
        if (summTextField != nil) && (chooseTheCatButton.text != "") {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let income = IncomeData(actualDate: dateFormatter.string(from: datePicker.date), cashAccount: chooseBillButton.text ?? "", category: chooseTheCatButton.text ?? "", contractor: chooseAgentButton.text ?? "", description: descriptionTextView.text, status: true, sumOfTransaction: Int(summTextField.text ?? "") ?? 0, tags: tagTextFied.text ?? "")
            let postRequest = APIRequest(endpoint: "expense_transaction")
            postRequest.save(income, completion: { result in

                switch result {
                case .success(let message):
                    
                    print("SUCCCESS \(message.message)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Вывод", message: message.message, preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                           
                                self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true)
                        
                    }
                    
                case .failure(let error):
                    print("ERROR: \(error)")
                }
               
                

            })
            
            
        } else {
            let alert = UIAlertController(title: "Не заполнены обязательные поля", message: "Пожалуйста заполните поля зеленого цвета", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))

            self.present(alert, animated: true)
            chooseAgentButton.text = ""
            summTextField.text = ""
            tagTextFied.text = ""
            chooseBillButton.text = "Выбрать счет ▼"
            chooseTheCatButton.text = ""
            descriptionTextView.text = ""
            chooseProjectButton.text = "Выбрать проект(Не обяз.) ▼"
        }
    
    }
}

extension AddExpenditureViewController: UITableViewDelegate, UITableViewDataSource {
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
