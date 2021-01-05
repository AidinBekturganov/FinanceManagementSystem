//
//  ChangePasswordViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/19/20.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var confirmationTextField: UITextField!
    
    @IBOutlet weak var sendDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextField.becomeFirstResponder()
        createAButton()
        warningLabel.isHidden = true
        setGestureToDissmis()
    }
    
    func setGestureToDissmis() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func createAButton() {
        sendDataButton.layer.cornerRadius = 16
        sendDataButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sendDataButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        sendDataButton.layer.shadowOpacity = 0.8
        sendDataButton.layer.shadowRadius = 0.0
        sendDataButton.layer.masksToBounds = false
    }
    
    
    
    @IBAction func sendNewData(_ sender: Any) {
        
        if oldPasswordTextField.text != "" && newPasswordTextField.text != "" && confirmationTextField.text != "" {
            if newPasswordTextField.text?.count ?? 0 > 9 && confirmationTextField.text == newPasswordTextField.text {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                
                //                let data = ChangePassword(confirmNewPassword: "Bishkek2020", newPassword: "Bishkek2020", oldPassword: "123456Bishkek")
                //
                let data = ChangePassword(confirmNewPassword: confirmationTextField.text ?? "", newPassword: newPasswordTextField.text ?? "", oldPassword: oldPasswordTextField.text ?? "")
                
                let postRequest = APIRequest(endpoint: "users/me/change-password")
                postRequest.changePassword(data, completion: { result in
                    
                    switch result {
                    case .success(let message):
                        
                        print("SUCCCESS \(message.message)")
                        DispatchQueue.main.async {
                            self.warningLabel.isHidden = false
                            self.warningLabel.text = "Пароль успешно сменен!"
                            self.warningLabel.textColor = .green
                            
                            
                            //                    self.indicatorView.stopAnimating()
                            //                    self.view.isUserInteractionEnabled = true
                            //                    self.successImageView.isHidden = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                    case .failure(let error):
                        
                        DispatchQueue.main.async {
                            //                    self.indicatorView.stopAnimating()
                            //                    self.view.isUserInteractionEnabled = true
                            let alert = UIAlertController(title: "Ошибка сервера", message: "Попробуйте отправить запрос позже или обратитесь администратору", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }))
                            self.present(alert, animated: true)
                        }
                        print("ERROR: \(error)")
                    }
                })
            }
        } else {
            warningLabel.isHidden = false
        }
        
        
    }
    
}

