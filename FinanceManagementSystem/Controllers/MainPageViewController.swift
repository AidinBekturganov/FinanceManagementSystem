//
//  MainPageViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 11/20/20.
//

import UIKit
import PieCharts
import ChartLegends

class MainPageViewController: UIViewController {

    @IBOutlet weak var legendsView: ChartLegendsView!
    @IBOutlet weak var pieChartView: PieChart!
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var expendView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeView.layer.cornerRadius = 10
        incomeView.layer.borderWidth = 1
        incomeView.layer.borderColor = UIColor(red: 36/255, green: 180/255, blue: 130/255, alpha: 1).cgColor
        expendView.layer.cornerRadius = 10
        expendView.layer.borderWidth = 1
        expendView.layer.borderColor = UIColor(red: 36/255, green: 180/255, blue: 130/255, alpha: 1).cgColor
        
        model.getAccounts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        pieChartView.models = [
            PieSliceModel(value: 2.1, color: UIColor.yellow),
            PieSliceModel(value: 3, color: UIColor.blue),
            PieSliceModel(value: 1, color: UIColor.green)
        ]
        
        legendsView.setLegends(.circle(radius: 7), [
            (text: "Chemicals", color: UIColor.orange),
            (text: "Forestry", color: UIColor.green),
            (text: "Chemicals", color: UIColor.orange),
            (text: "Forestry", color: UIColor.green),
            (text: "Chemicals", color: UIColor.orange),
            (text: "Forestry", color: UIColor.green),
            (text: "Chemicals", color: UIColor.orange),
            (text: "Forestry", color: UIColor.green)
        ])
    }


}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForBills", for: indexPath) as! BillsTableViewCell
        
        cell.accs = model.accounts[indexPath.row]
        
        
        return cell
    }
    
    
}
