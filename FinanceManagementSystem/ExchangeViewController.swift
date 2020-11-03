//
//  ExchangeViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 10/27/20.
//

import UIKit
import iOSDropDown


class CellClassForExchange: UITableViewCell {
    
}

class ExchangeViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var summTextField: UITextField!
    @IBOutlet weak var exchangeFromTheBillOne: UIButton!
    @IBOutlet weak var exchangeToTheBill: UIButton!
    @IBOutlet weak var test: DropDown!
    @IBOutlet weak var commentTextField: UITextView!
    
    
    let transparetView = UIView()
    let tableView = UITableView()
    var dataSource = [String]()
    let date = Date()
    var selectedButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClassForExchange.self, forCellReuseIdentifier: "Cell")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        timeLabel.text = dateFormatter.string(from: date)
        // The list of array to display. Can be changed dynamically
        test.optionArray = ["Option 1", "Option 2", "Option 3"]
        //Its Id Values and its optional
        test.optionIds = [1,23,54,22]
        test.selectedRowColor = .clear
        test.didSelect{(selectedText , index ,id) in
        var i = "Selected String: \(selectedText) \n index: \(String(describing: index))"
            print(i)
            var a = self.test.text
            print(a)
            }
        
        }
    
    func addTransperenty(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparetView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparetView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparetView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tappGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransperenteView))
        transparetView.addGestureRecognizer(tappGesture)
        transparetView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparetView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransperenteView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparetView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }

    
    @IBAction func changeButtonFromPressed(_ sender: Any) {
        dataSource = ["Банк счет", "Элсом", "Касса"]
        selectedButton = exchangeFromTheBillOne
        addTransperenty(frames: exchangeFromTheBillOne.frame)
    }
    
    
    @IBAction func changeButtonToPressed(_ sender: Any) {
        dataSource = ["Банк счет", "Элсом", "Касса"]
        selectedButton = exchangeToTheBill
        addTransperenty(frames: exchangeToTheBill.frame)
    }
}


extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransperenteView()
    }
    
    
}
