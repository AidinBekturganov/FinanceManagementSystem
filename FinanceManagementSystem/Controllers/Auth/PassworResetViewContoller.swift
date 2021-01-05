//
//  PassworResetViewContoller.swift
//  FinanceManagementSystem
//
//  Created by User on 12/18/20.
//

import UIKit

class PassworResetViewContoller: UIViewController {

    @IBOutlet weak var textFieldForEmail: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldForEmail.attributedPlaceholder = NSAttributedString(string: "neobis@gmail.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    

    @IBAction func cancelButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
    }
    
}
