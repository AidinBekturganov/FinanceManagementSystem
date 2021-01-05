//
//  FilterOfJournalViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/13/20.
//

import UIKit

struct FilteredValiables {
    var dateFrom: Date
    var dateTo: Date
    var cashAccount: String
    var type: String
    var contractor: String
}

class FilterOfJournalViewController: UIViewController {
    
    @IBOutlet weak var cashAccountButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var datePickerFrom: UIDatePicker!
    @IBOutlet weak var datePickerTo: UIDatePicker!
    @IBOutlet weak var contractorButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    var filterItem: FilteredValiables!
    
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    let defaults = UserDefaults()
    var selectedTextField = UITextView()
    var indicatorView = UIActivityIndicatorView()
    var namesOfAgents = [String]()
    var incomeCategories = [String]()
    var categories = [String]()
    let model = Model()
    let date = Date()
    var theChooseFromPickerView: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerFrom.setDate(Date().addingTimeInterval((-24*60*60) * 30), animated: true)
        
        getCategory {
            self.getAgents {
                self.model.getAccounts {
                    self.getCategoryOfExpense {
                        
                        DispatchQueue.main.async {
                            self.indicatorView.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        }
                    }
                }
            }
        }
        
        createAButton()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        filterItem = FilteredValiables(dateFrom: datePickerFrom.date, dateTo: datePickerTo.date, cashAccount: cashAccountButton.titleLabel?.text ?? "" == "Выбрать счет" ? "" : cashAccountButton.titleLabel?.text ?? "", type: typeButton.titleLabel?.text ?? "" == "Выбрать тип" ? "" : typeButton.titleLabel?.text ?? "", contractor: contractorButton.titleLabel?.text ?? "" == "Выбрать контрагента" ? "" : contractorButton.titleLabel?.text ?? "")
    }
    
    
    func setupIndicator() {
        indicatorView.center = self.view.center
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = UIColor.white
        view.addSubview(indicatorView)
        
    }
    
    func transitionViewController() {
        
        let authPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.authViewController) as? AuthViewController
        
        view.window?.rootViewController = authPage
        view.window?.makeKeyAndVisible()
        
    }
    
    
    
    func createAButton() {
        filterButton.layer.cornerRadius = 16
        filterButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        filterButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        filterButton.layer.shadowOpacity = 0.8
        filterButton.layer.shadowRadius = 0.0
        filterButton.layer.masksToBounds = false
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
                    self.namesOfAgents.append(result[index].name ?? "Без имени")
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
    
    func getCategoryOfExpense(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/expenses_categories/not_archived"
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
                    self.incomeCategories.append(result[index].categoryName ?? "Без назавния")
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
                    self.incomeCategories.append(result[index].categoryName ?? "Без назавния")
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
    
    func getProjects(completed: @escaping () -> ()) {
        let urlString = "https://fms-neobis.herokuapp.com/projects/not_archived"
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
                    self.categories.append(result[index].name ?? "Без названия")
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
    
    private func pickerViewFire(selectedButton: UIButton) {
        
        let message = "\n\n\n\n\n\n"
        let alert = UIAlertController(title: "Выберите один из варинтов", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: view.frame.width - 20, height: 140)) // CGRectMake(left, top, width, height) - left and top are like margins
        pickerFrame.tag = 555
        //set the pickers datasource and delegate
        pickerFrame.delegate = self
        
        //Add the picker to the alert controller
        pickerFrame.dataSource = self
        alert.view.addSubview(pickerFrame)
        let okAction = UIAlertAction(title: "Готово", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if self.theChooseFromPickerView == "" && !self.dataSource.isEmpty {
                selectedButton.setTitle( self.dataSource[0], for: .normal)
                print("HERE IT SI \(self.dataSource[0])")
                self.theChooseFromPickerView = ""
                self.dataSource = []
            } else if self.dataSource.isEmpty {
                
            } else {
                selectedButton.setTitle( self.theChooseFromPickerView, for: .normal)
                self.theChooseFromPickerView = ""
                self.dataSource = []
            }
            
            
            
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Отменить", style: .destructive, handler: {_ in
            self.theChooseFromPickerView = ""
            self.dataSource = []
        })
        alert.addAction(cancelAction)
        self.parent!.present(alert, animated: true, completion: {  })
        
    }
    
    
    @IBAction func categoryPressed(_ sender: Any) {
        
        dataSource = incomeCategories
        selectedButton = categoryButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func cashButtonPressed(_ sender: Any) {
        
        dataSource = model.accountsArray
        selectedButton = cashAccountButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        
        dataSource = ["Доход", "Расход", "Перевод"]
        //dataSource.append("Без контрагента")
        selectedButton = typeButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func agentButtonPressed(_ sender: Any) {
        
        dataSource = namesOfAgents
        //dataSource.append("Без контрагента")
        selectedButton = contractorButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
    }
    
}


extension FilterOfJournalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !dataSource.isEmpty {
            theChooseFromPickerView = dataSource[row]
        }
        
        //  print("HERE IT IS \(theChooseFromPickerView)")
    }
    
}
