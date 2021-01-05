//
//  ConfirmationViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/18/20.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var textFieldForCode: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var doneImageView: UIImageView!
    @IBOutlet weak var textFieldForPassword: UITextField!
    
    let indicatorView = UIActivityIndicatorView()
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldForCode.becomeFirstResponder()
        textFieldForCode.attributedPlaceholder = NSAttributedString(string: "-----",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)])
        textFieldForPassword.attributedPlaceholder = NSAttributedString(string: "**********",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)])
        setButton()
        setupIndicator()
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
    
    
    func transitionViewController() {
        
        let authPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.authViewController) as? AuthViewController
        
        view.window?.rootViewController = authPage
        view.window?.makeKeyAndVisible()
        
    }
    
    func setButton() {
        confirmButton.layer.cornerRadius = 16
        confirmButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        confirmButton.layer.shadowOpacity = 0.8
        confirmButton.layer.shadowRadius = 0.0
        confirmButton.layer.masksToBounds = false
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        transitionViewController()
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        if textFieldForCode.text != "" && textFieldForPassword.text != "" && textFieldForPassword.text?.count ?? 0 > 9 {
            self.indicatorView.startAnimating()
            self.view.isUserInteractionEnabled = false
            model.sendCodeAndPasswordToReset(code: textFieldForCode.text ?? "", password: textFieldForPassword.text ?? "") {
                DispatchQueue.main.async {
                    if self.model.sendCodeAndPassData == "SUCCESS" {
                        self.doneImageView.image = UIImage(named: "Done")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.transitionViewController()
                            self.indicatorView.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        }
                        
                    } else {
                        self.indicatorView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.doneImageView.tintColor = .red
                        self.doneImageView.image = UIImage(named: "Lock")
                        self.textFieldForCode.text = ""
                        self.textFieldForCode.attributedPlaceholder = NSAttributedString(string: "------", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 248/255, green: 119/255, blue: 125/255, alpha: 0.7)])
                        self.textFieldForPassword.text = ""
                        self.textFieldForPassword.attributedPlaceholder = NSAttributedString(string: "********", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 248/255, green: 119/255, blue: 125/255, alpha: 0.7)])
                    }
                }
                
                
            }
        } else {
            self.indicatorView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.doneImageView.tintColor = .red
            self.doneImageView.image = UIImage(named: "Lock")
            self.textFieldForCode.text = ""
            self.textFieldForCode.attributedPlaceholder = NSAttributedString(string: "------", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 248/255, green: 119/255, blue: 125/255, alpha: 0.7)])
            self.textFieldForPassword.text = ""
            self.textFieldForPassword.attributedPlaceholder = NSAttributedString(string: "********", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 248/255, green: 119/255, blue: 125/255, alpha: 0.7)])
        }
        
    }
    
}
