//
//  AddIncomeViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 10/24/20.
//

import UIKit
import iOSDropDown


struct Accounts {
    var name: String
    var sumInAccounts: Double
}


class CellClass: UITableViewCell {
    
}


class AddIncomeViewController: UIViewController {

    @IBOutlet weak var textFieldForSumm: UITextField!
    @IBOutlet weak var chooseBillButton: DropDown!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textFieldForTags: UITextField!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var chooseProjectButton: DropDown!
    @IBOutlet weak var textFieldForContractor: DropDown!
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var chooseTheCatefory: DropDown!
    

    
    let transparetView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var selectedTextField = UITextView()
    var indicatorView = UIActivityIndicatorView()

    var dataSource = [String]()
    
    
    var namesOfAgents = [String]()
    var incomeCategories = [String]()
    var categories = [String]()

    var accounts = [Accounts]()
    

    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        setupIndicator()
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        getProjects {
        }
        
        getAccounts {
            print("sa")
        }
        
        
      
        getCategory {
            print("DONE")
            self.getAgents {
                print("Ready")
                DispatchQueue.main.async {
                    self.createDropDownButtons()
                    self.indicatorView.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
             
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
        let urlString = "https://fms-neobis.herokuapp.com/incomes_categories"
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
        textFieldForContractor.optionArray = namesOfAgents
        chooseTheCatefory.optionArray = incomeCategories
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
        
        textFieldForContractor.text = ""
        textFieldForSumm.text = ""
        textFieldForTags.text = ""
        chooseBillButton.text = "Выбрать счет"
        chooseTheCatefory.text = ""
        descriptionTextView.text = ""
        chooseProjectButton.text = "Выбрать проект(Не обяз.)"
    }
    
    
    @IBAction func addBarButtonPressed(_ sender: Any) {
        if (textFieldForSumm != nil) && (chooseTheCatefory.text != "") && (chooseBillButton.text != "Выбрать счет"){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let income = IncomeData(actualDate: dateFormatter.string(from: datePicker.date), cashAccount: chooseBillButton.text ?? "", category: chooseTheCatefory.text ?? "", contractor: textFieldForContractor.text ?? "", description: descriptionTextView.text, status: true, sumOfTransaction: Int(textFieldForSumm.text ?? "") ?? 0, tags: textFieldForTags.text ?? "")
            let postRequest = APIRequest(endpoint: "income_transaction")
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
            textFieldForContractor.text = ""
            textFieldForSumm.text = ""
            textFieldForTags.text = ""
            chooseBillButton.text = "Выбрать счет"
            chooseTheCatefory.text = ""
            descriptionTextView.text = ""
            chooseProjectButton.text = "Выбрать проект(Не обяз.)"
        }
        
    }
}


extension AddIncomeViewController: UITableViewDelegate, UITableViewDataSource {
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
