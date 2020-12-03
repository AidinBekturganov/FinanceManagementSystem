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
    

    let defaults = UserDefaults()
    let transparetView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var selectedTextField = UITextView()
    var indicatorView = UIActivityIndicatorView()

    var dataSource = [String]()
    
    
    var namesOfAgents = [String]()
    var incomeCategories = [String]()
    var categories = [String]()
    let model = Model()

 
    

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
        
        model.getAccounts {
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
        textFieldForSumm.layer.cornerRadius = 8
        chooseBillButton.layer.cornerRadius = 8
        textFieldForTags.layer.cornerRadius = 8
        chooseProjectButton.layer.cornerRadius = 8
        textFieldForContractor.layer.cornerRadius = 8
        chooseTheCatefory.layer.cornerRadius = 8
        descriptionTextView.layer.cornerRadius = 8
    }
  
    

    
     func getAgents(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/contractors/not_archived"
        
        
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
                let result: [Agents] = try JSONDecoder().decode([Agents].self, from: data!)
                print(result)
                for index in 0..<result.count {
                    print(result[index].name)
                    self.namesOfAgents.append(result[index].name ?? "-")
                }
            } catch {
                
                print("ERROR")
            }
            completed()
            
        }
        task.resume()
            
    }
    
     func getCategory(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/incomes_categories/not_archived"
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
                let result: [IncomeCategories] = try JSONDecoder().decode([IncomeCategories].self, from: data!)
                print(result)
                for index in 0..<result.count {
                    print(result[index].categoryName)
                    self.incomeCategories.append(result[index].categoryName ?? "")
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
        
        let token = defaults.object(forKey:"token") as? String ?? ""
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }
            do {
                let result: [Categories] = try JSONDecoder().decode([Categories].self, from: data!)
                print(result)
                for index in 0..<result.count {
                    print(result[index].name)
                    self.categories.append(result[index].name ?? "")
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
        for i in 0..<model.accounts.count {
            acounts.append(model.accounts[i].name)
        }
        textFieldForContractor.optionArray = namesOfAgents
        chooseTheCatefory.optionArray = incomeCategories
        chooseBillButton.optionArray = acounts
        chooseProjectButton.optionArray = categories
        textFieldForContractor.checkMarkEnabled = false
        chooseTheCatefory.checkMarkEnabled = false
        chooseProjectButton.checkMarkEnabled = false
        chooseBillButton.checkMarkEnabled = false
        textFieldForContractor.selectedRowColor = .black
        chooseBillButton.selectedRowColor = .black
        chooseTheCatefory.selectedRowColor = .black
        chooseProjectButton.selectedRowColor = .black

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
        if (textFieldForSumm.text != "") && (chooseTheCatefory.text != "") && (chooseBillButton.text != "Выбрать счет"){
            setupIndicator()
            indicatorView.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
    
            let income = IncomeData(actualDate: dateFormatter.string(from: datePicker.date), cashAccount: chooseBillButton.text ?? "", category: chooseTheCatefory.text ?? "", contractor: textFieldForContractor.text ?? "", description: descriptionTextView.text, status: true, sumOfTransaction: Int(textFieldForSumm.text ?? "") ?? 0, tags: textFieldForTags.text ?? "")
            
            let postRequest = APIRequest(endpoint: "income_transaction")
            postRequest.save(income, completion: { result in

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
//            textFieldForContractor.text = ""
//            textFieldForSumm.text = ""
//            textFieldForTags.text = ""
//            chooseBillButton.text = "Выбрать счет"
//            chooseTheCatefory.text = ""
//            descriptionTextView.text = ""
//            chooseProjectButton.text = "Выбрать проект(Не обяз.)"
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
    }
    
}
