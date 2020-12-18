//
//  ResetViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/18/20.
//

import UIKit

class ResetViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.attributedPlaceholder = NSAttributedString(string: "neobis@gmail.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)])
        setButton()
        
    }
    
    func transitionViewController() {
        
        let confirm = storyboard?.instantiateViewController(identifier: Constants.Storyboard.confirmationViewController) as? ConfirmationViewController
        
        view.window?.rootViewController = confirm
        view.window?.makeKeyAndVisible()
        
    }
    
    func setButton() {
        resetButton.layer.cornerRadius = 16
        resetButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        resetButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        resetButton.layer.shadowOpacity = 0.8
        resetButton.layer.shadowRadius = 0.0
        resetButton.layer.masksToBounds = false
    }


    @IBAction func cancelButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        if emailField.text != "" {
            model.sendEmailToReset(email: emailField.text ?? "") {
                DispatchQueue.main.async {
                    if self.model.sendEmailData == "SUCCESS" {
                        self.transitionViewController()
                    } else {
                        self.emailField.text = ""
                        self.emailField.attributedPlaceholder = NSAttributedString(string: "Неправильный логин", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 248/255, green: 119/255, blue: 125/255, alpha: 0.7)])
                    }
                }
                
            }

        }
    }
    
}
