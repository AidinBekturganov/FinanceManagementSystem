//
//  AuthViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 11/14/20.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var loginFIedl: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var viewForCoinsImage: UIView!
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var indicatorView = UIActivityIndicatorView()
    var authtoken = ""
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let login = userDefaults.object(forKey:"login") as? String ?? "" {
            loginFIedl.text = login
        }
        
        if let checkmark = userDefaults.object(forKey:"checkmark") as? Bool ?? false {
            checkMark.isSelected = checkmark
            if checkmark == true {
                
                
                
                if let password = userDefaults.object(forKey:"password") as? String ?? "" {
                    passwordField.text = password
                }
                
            }
        }
        if loginFIedl.text == "" {
            loginFIedl.becomeFirstResponder()
        }
        
        loginFIedl.attributedPlaceholder = NSAttributedString(string: "neobis@gmail.com",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "******",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)])
        UIGraphicsBeginImageContext(viewForCoinsImage.frame.size)
        UIImage(named: "coin")?.draw(in: viewForCoinsImage.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        viewForCoinsImage.contentMode = UIView.ContentMode.scaleToFill
        viewForCoinsImage.backgroundColor = UIColor(patternImage: image)
        
        signInButton.layer.cornerRadius = 16
        signInButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signInButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        signInButton.layer.shadowOpacity = 0.8
        signInButton.layer.shadowRadius = 0.0
        signInButton.layer.masksToBounds = false
        
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
    
    struct User: Codable {
        var email: String
        var password: String
    }
    
    
    
    @IBAction func passW(_ sender: Any) {
        //        let getProjects = "https://fms-neobis.herokuapp.com/users/me"
        //        guard let url = URL(string: getProjects) else { return }
        //        var request = URLRequest(url: url)
        //        request.setValue("Bearer \(authtoken)", forHTTPHeaderField: "Authorization")
        //        //request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        //
        //        let session = URLSession.shared
        //
        //        let task = session.dataTask(with: request) { (data, response, error) in
        //            if let error = error {
        //                print("Error: \(error)")
        //            }
        //
        //            do {
        //                let result = try JSONDecoder().decode(User.self, from: data ?? Data())
        //                print(result)
        //
        //            } catch {
        //                print("ERROR IN CATCH")
        //            }
        //        }
        //        task.resume()
    }
    
    @IBAction func checkPressed(_ sender: Any) {
        if checkMark.isSelected == false {
            checkMark.isSelected = true
            
        } else if checkMark.isSelected == true {
            
            checkMark.isSelected = false
            self.userDefaults.set(checkMark.isSelected, forKey: "checkmark")
            
            
        }
    }
    
    @IBAction func unwindFromPasswordReset(segue: UIStoryboardSegue) {
        let source = segue.source as! ResetViewController
        
    }
    
    @IBAction func unwindFromConfirmation(segue: UIStoryboardSegue) {
        let source = segue.source as! ConfirmationViewController
        
    }
    
    func transitionViewController() {
        
        let mainPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainPages) as? UITabBarController
        
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let authData = User(email: loginFIedl.text ?? "", password: passwordField.text ?? "")
        if authData.email == "" && authData.password == "" {
            
        } else {
            self.indicatorView.startAnimating()
            self.view.isUserInteractionEnabled = false
            guard let login = URL(string: "https://fms-neobis.herokuapp.com/login") else {
                print("ERROR IN LOGIN URL")
                return
                
            }
            
            let parameters = ["email": "finance.mng5@gmail.com", "password": "Bishkek2020"]
            struct tokenAr: Codable {
                var token: String
            }
            
            
            
            do {
                var urlRequest = URLRequest(url: login)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try JSONEncoder().encode(authData)
                
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                        
                        print("ERROR IN HTTPRESP")
                        
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Ошибка", message: "Неправильный логин или пароль, повторите попытку еще раз", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                                
                                self.indicatorView.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                self.loginLabel.textColor = UIColor(red: 248/255, green: 119/255, blue: 125/255, alpha: 1)
                                
                                self.passwordLabel.textColor = UIColor(red: 248/255, green: 119/255, blue: 125/255, alpha: 1)
                                
                            }))
                            self.present(alert, animated: true)
                        }
                        return
                    }
                    
                    
                    if let data = data {
                        do {
                            let messageData = try JSONDecoder().decode(tokenAr.self, from: jsonData)
                            self.authtoken = messageData.token
                            print(messageData.token)
                            
                            self.userDefaults.set(messageData.token, forKey: "token")
                            
                            DispatchQueue.main.async {
                                if self.checkMark.isSelected {
                                    
                                    self.userDefaults.set(self.checkMark.isSelected, forKey: "checkmark")
                                    self.userDefaults.set(self.loginFIedl.text, forKey: "login")
                                    self.userDefaults.set(self.passwordField.text, forKey: "password")
                                    
                                    
                                }
                                self.indicatorView.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                self.transitionViewController()
                                
                            }
                            
                        } catch {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Ошибка сервера", message: "Ошибка сервера, сервер не вернул ответ, попробуйте отправить запрос позже", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                                    
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }))
                                self.present(alert, animated: true)
                            }
                            print("ERROR IN CATCH")
                        }
                    }
                    
                }
                
                dataTask.resume()
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка сервера", message: "", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }))
                    self.present(alert, animated: true)
                }
                print("ERROE IN CATCH")
            }
            
        }
    }
    
    
}
