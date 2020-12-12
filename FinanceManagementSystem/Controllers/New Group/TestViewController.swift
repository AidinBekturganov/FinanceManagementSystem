//
//  TestViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 11/19/20.
//

import UIKit
import PieCharts

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        chartview.models = [
            PieSliceModel(value: 5000, color: UIColor(red: 166/255, green: 177/255, blue: 1/255, alpha: 1)),
            PieSliceModel(value: 1000, color: UIColor(red: 166/255, green: 177/255, blue: 166/255, alpha: 1)),
            PieSliceModel(value: 3000, color: UIColor(red: 166/255, green: 166/255, blue: 1/255, alpha: 1)),
            PieSliceModel(value: 5000, color: UIColor(red: 166/255, green: 177/255, blue: 1/255, alpha: 1)),
            PieSliceModel(value: 1000, color: UIColor(red: 166/255, green: 177/255, blue: 177/255, alpha: 1)),
            PieSliceModel(value: 3000, color: UIColor(red: 166/255, green: 177/255, blue: 1/255, alpha: 1)),
            PieSliceModel(value: 5000, color: UIColor(red: 177/255, green: 177/255, blue: 1/255, alpha: 1)),
            PieSliceModel(value: 1000, color: UIColor(red: 166/255, green: 255/255, blue: 1/255, alpha: 1)),
            PieSliceModel(value: 3000, color: UIColor(red: 255/255, green: 177/255, blue: 1/255, alpha: 1))
        ]
    }
    @IBOutlet weak var chartview: PieChart!
    


}
