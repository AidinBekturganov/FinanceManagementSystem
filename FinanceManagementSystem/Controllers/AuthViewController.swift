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
    
    var indicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(viewForCoinsImage.frame.size)
           UIImage(named: "coin")?.draw(in: viewForCoinsImage.bounds)
           let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
        viewForCoinsImage.contentMode = UIView.ContentMode.scaleToFill
        viewForCoinsImage.backgroundColor = UIColor(patternImage: image)
        
        
        //viewForCoinsImage.backgroundColor = UIColor(patternImage: UIImage(named: "coin") ?? UIImage())
        signInButton.layer.cornerRadius = 16
        signInButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signInButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        signInButton.layer.shadowOpacity = 0.8
        signInButton.layer.shadowRadius = 0.0
        signInButton.layer.masksToBounds = false
//        signInButton.layer.borderWidth = 1
//        signInButton.layer.borderColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.85).cgColor
        
//        let cash = CreatCashAccount(name: "Санира")
//
//        let postRequest = APIRequest(endpoint: "contractors")
//        postRequest.saveNewCashAccount(cash, completion: { result in
//
//            switch result {
//            case .success(let message):
//
//                print("SUCCCESS \(message.message)")
//                DispatchQueue.main.async {
//                    //                self.indicatorView.stopAnimating()
//                    //                self.view.isUserInteractionEnabled = true
//                    let alert = UIAlertController(title: "Вывод", message: message.message, preferredStyle: .alert)
//
//                    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
//
//                        //self.navigationController?.popViewController(animated: true)
//
//                    }))
//                    self.present(alert, animated: true)
//
//                }
//
//            case .failure(let error):
//                print("ERROR: \(error)")
//            }
//
//
//
//        })
        
        setupIndicator()
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
        var username: String
    }
    
    var authtoken = ""
    let userDefaults = UserDefaults.standard
    
    @IBAction func passW(_ sender: Any) {
        let getProjects = "https://fms-neobis.herokuapp.com/users/me"
        guard let url = URL(string: getProjects) else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authtoken)", forHTTPHeaderField: "Authorization")
        //request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }
            
            do {
                let result = try JSONDecoder().decode(User.self, from: data ?? Data())
                print(result)
                
            } catch {
                print("ERROR IN CATCH")
            }
        }
        task.resume()
    }
    
    func transitionViewController() {
        
        let mainPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainPages) as? PageViewController
        
        view.window?.rootViewController = mainPage
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
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
            urlRequest.httpBody = try JSONEncoder().encode(parameters)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                   
                    print("ERROR IN HTTPRESP")
                    self.indicatorView.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Ошибка", message: "Неправильный логин или пароль, повторите попытку еще раз", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (i) in
                            
                            
                            
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
