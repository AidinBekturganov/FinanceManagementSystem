//
//  AddIncomeViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 10/24/20.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .current
    dateFormatter.locale = .current
    dateFormatter.dateFormat = "mm/dd/yyyy"
    return dateFormatter
}()

class CellClass: UITableViewCell {
    
}

class AddIncomeViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textFieldForSumm: UITextField!
    @IBOutlet weak var chooseBillButton: UIButton!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    @IBOutlet weak var projectChooseButton: UIButton!
    @IBOutlet weak var agentChooseButton: UIButton!
    @IBOutlet weak var chooseTheProjectButton: UIButton!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var chooseTheAgentButton: UIButton!
    
    let transparetView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        dateLabel.text = dateFormatter.string(from: date)
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
    
    @IBAction func chooseTheBillPressed(_ sender: Any) {
        dataSource = ["Банк счет", "Элсом", "Касса"]
        selectedButton = chooseBillButton
        addTransperenty(frames: chooseBillButton.frame)
    }
    @IBAction func chooseProjectButtonPressed(_ sender: Any) {
        dataSource = ["Комм проект 1", "Комм проект 2", "JAVA курсы", "JavaScript курсы"]
        selectedButton = chooseTheProjectButton
        addTransperenty(frames: chooseTheProjectButton.frame)
    }
    @IBAction func chooseTheAgentButtonPressed(_ sender: Any) {
        dataSource = ["Санира", "Айсалкын", "Медина"]
        selectedButton = chooseTheAgentButton
        addTransperenty(frames: chooseTheAgentButton.frame)
    }
    
    @IBAction func chooseTheCatPressed(_ sender: Any) {
        dataSource = ["Курсы", "ЧВ", "Студии", "Спонсторство"]
        selectedButton = chooseCategoryButton
        addTransperenty(frames: chooseCategoryButton.frame)
    }
    
    @IBAction func addBarButtonPressed(_ sender: Any) {
        if textFieldForSumm != nil && chooseBillButton.titleLabel?.text != "Выбрать счет ▼" && chooseCategoryButton.titleLabel?.text != "Выбрать категорию ▼"{
            print("SUCCESS ADDED \(textFieldForSumm.text) \(chooseBillButton.titleLabel?.text) \(chooseCategoryButton.titleLabel?.text)")
        }
        //navigationController?.popViewController(animated: true)
    }
    
}

extension AddIncomeViewController: UITableViewDelegate, UITableViewDataSource {
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
