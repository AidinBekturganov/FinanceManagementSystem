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
    @IBOutlet weak var successCheckMarkImageView: UIImageView!
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    let defaults = UserDefaults()
    var selectedTextField = UITextView()
    var indicatorView = UIActivityIndicatorView()
    let model = Model()
    let date = Date()
    var theChooseFromPickerView: String? = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sumTextFirld.becomeFirstResponder()
        self.successCheckMarkImageView.isHidden = true
        model.getCategoryExpense {
            self.model.getAgents {
                self.model.getAccounts {
                    self.model.getProjects {
                        DispatchQueue.main.async {
                            self.indicatorView.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        }
                    }
                }
            }
        }
        
        createAButton()
        setGestureToDissmis()
    }
    
    func setGestureToDissmis() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func setupIndicator() {
        indicatorView.center = self.view.center
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = UIColor.white
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
    
    func transitionBackToViewController() {
        
        let journalPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainPages) as? UITabBarController
        
        view.window?.rootViewController = journalPage
        view.window?.makeKeyAndVisible()
        
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
        
        dataSource = model.incomeCategories
        selectedButton = categoryButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func cashButtonPressed(_ sender: Any) {
        
        dataSource = model.accountsArray
        selectedButton = cashAccount
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func projectButtonPressed(_ sender: Any) {
        
        dataSource = model.categories
        selectedButton = projectButtin
        dataSource.append("Без проекта")
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func agentButtonPressed(_ sender: Any) {
        
        dataSource = model.namesOfAgents
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
            
            let income = IncomeData(actualDate: dateFormatter.string(from: datePicker.date), cashAccount: cashAccount.titleLabel?.text ?? "", category: categoryButton.titleLabel?.text ?? "", contractor: (agentButton.titleLabel?.text == "Без контрагента" ? nil : agentButton.titleLabel?.text), description: descriptionButton.text == "" ? nil : descriptionButton.text, status: true, project: (projectButtin.titleLabel?.text == "Без проекта" ? nil : projectButtin.titleLabel?.text), sumOfTransaction: Int(sumTextFirld.text ?? "") ?? 0)
            
            
            let postRequest = APIRequest(endpoint: "expense_transaction")
            postRequest.save(income, completion: { result in
                
                switch result {
                case .success(let message):
                    
                    print("SUCCCESS \(message.message)")
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.successCheckMarkImageView.isHidden = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.transitionBackToViewController()
                        }
                        
                        
                        
                        
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



extension ExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        theChooseFromPickerView = dataSource[row]
        print("HERE IT IS \(theChooseFromPickerView)")
    }
    
}

