//
//  ProfileViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/18/20.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    let model = Model()
    let defualts = UserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.getInfoAboutUser {
            DispatchQueue.main.async {
                self.nameLabel.text = self.model.userdata.username
                self.emailLabel.text = self.model.userdata.email
                self.phoneNumberLabel.text = self.model.userdata.number
            }
        }
        
    }
    
    func transitionViewController() {
        
        let authPage = storyboard?.instantiateViewController(identifier: Constants.Storyboard.authViewController) as? AuthViewController
        
        view.window?.rootViewController = authPage
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.defualts.removeObject(forKey: "token")
        transitionViewController()
    }
    
    
}
