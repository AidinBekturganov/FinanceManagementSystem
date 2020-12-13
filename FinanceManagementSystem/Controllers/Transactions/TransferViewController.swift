//
//  TransferViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/11/20.
//

import UIKit

class TransferViewController: UIViewController {

    @IBOutlet weak var sumTextFirld: UITextField!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tagTextFirld: UITextField!
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

        model.getAccounts {
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
        
         createAButton()
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
        addButton.layer.cornerRadius = 16
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        addButton.layer.shadowOpacity = 0.8
        addButton.layer.shadowRadius = 0.0
        addButton.layer.masksToBounds = false
    }
    
    func transitionViewController() {
        
        let authPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.authViewController) as? AuthViewController
        
        view.window?.rootViewController = authPage
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
    
    
    
    @IBAction func fromButtonPressed(_ sender: Any) {

        dataSource = model.accountsArray
        selectedButton = fromButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func toButtonPressed(_ sender: Any) {

        dataSource = model.accountsArray
        selectedButton = toButton
        pickerViewFire(selectedButton: selectedButton)
    }
    
    @IBAction func addBittonPressed(_ sender: Any) {
        if sumTextFirld.text != "" && sumTextFirld.text != "0" && fromButton.titleLabel?.text != "Выбрать счет" && fromButton.titleLabel?.text != "" && toButton.titleLabel?.text != "Выбрать счет" && toButton.titleLabel?.text != "" {
            setupIndicator()
            indicatorView.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let exchange = ExchangeData(actualDate: dateFormatter.string(from: datePicker.date), fromCashAccount: fromButton.titleLabel?.text ?? "", toCashAccount: toButton.titleLabel?.text ?? "", tags: tagTextFirld.text == "" ? nil : tagTextFirld.text, description: descriptionButton.text == "" ? nil : descriptionButton.text, sumOfTransaction: Double(sumTextFirld.text ?? "") ?? 0.0)
           

            
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


extension TransferViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    }
    
}
