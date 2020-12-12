//
//  ExpenseViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/11/20.
//

import UIKit

class ExpenseViewController: UIViewController {

    @IBOutlet weak var sumTextFirld: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cashAccount: UIButton!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var projectButtin: UIButton!
    @IBOutlet weak var agentButton: UIButton!
    @IBOutlet weak var addIncomeButton: UIButton!
    @IBOutlet weak var descriptionButton: UITextView!
    
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

    }
    
    func setupIndicator() {
        indicatorView.center = self.view.center
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = UIColor.green
        view.addSubview(indicatorView)
    }
  
    
    func createAButton() {
        descriptionButton.layer.cornerRadius = 10
        addIncomeButton.layer.cornerRadius = 16
        addIncomeButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addIncomeButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        addIncomeButton.layer.shadowOpacity = 0.8
        addIncomeButton.layer.shadowRadius = 0.0
        addIncomeButton.layer.masksToBounds = false
    }
    
    func transitionViewController() {
        
        let authPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.authViewController) as? AuthViewController
        
        view.window?.rootViewController = authPage
        view.window?.makeKeyAndVisible()
        
    }
    
    
    private func pickerViewFire(selectedButton: UIButton) {
        
        let message = "\n\n\n\n\n\n"
        let alert = UIAlertController(title: "Please Select City", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
         
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: view.frame.width - 20, height: 140)) // CGRectMake(left, top, width, height) - left and top are like margins
        pickerFrame.tag = 555
        //set the pickers datasource and delegate
        pickerFrame.delegate = self
         
        //Add the picker to the alert controller
        pickerFrame.dataSource = self
        alert.view.addSubview(pickerFrame)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        self.parent!.present(alert, animated: true, completion: {  })
        
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
   
    func getCategory(completed: @escaping () -> ()) {
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
    
    
    
    @IBAction func categoryPressed(_ sender: Any) {
       
        dataSource = incomeCategories
        selectedButton = categoryButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func cashButtonPressed(_ sender: Any) {
  
        dataSource = model.accountsArray
        selectedButton = cashAccount
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func projectButtonPressed(_ sender: Any) {

        dataSource = categories
        selectedButton = projectButtin
        dataSource.append("Без проекта")
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func agentButtonPressed(_ sender: Any) {

        dataSource = namesOfAgents
        dataSource.append("Без контрагента")
        selectedButton = agentButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func addBittonPressed(_ sender: Any) {
        if sumTextFirld.text != "" && sumTextFirld.text != "0" && categoryButton.titleLabel?.text != "Выбрать категорию" && categoryButton.titleLabel?.text != "" && cashAccount.titleLabel?.text != "Выбрать счет" && cashAccount.titleLabel?.text != "" {
            setupIndicator()
            indicatorView.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let income = IncomeData(actualDate: dateFormatter.string(from: datePicker.date), cashAccount: cashAccount.titleLabel?.text ?? "", category: categoryButton.titleLabel?.text ?? "", contractor: agentButton.titleLabel?.text == "Выбрать контрагента" ? nil : agentButton.titleLabel?.text, description: descriptionButton.text == "" ? nil : descriptionButton.text, status: true, project: projectButtin.titleLabel?.text == "Выбрать проект" ? nil : projectButtin.titleLabel?.text, sumOfTransaction: Int(sumTextFirld.text ?? "") ?? 0, tags: tagTextField.text == "" ? nil : tagTextField.text)

            
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
            self.indicatorView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Вниммание", message: "Заполните обязательные поля", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                
                self.navigationController?.popViewController(animated: true)
                
            }))
            self.present(alert, animated: true)
        }
    }

}
