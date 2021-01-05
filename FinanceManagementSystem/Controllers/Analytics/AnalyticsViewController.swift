//
//  AnalyticsViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/14/20.
//

import UIKit
import Charts

class AnalyticsViewController: UIViewController {
    
    @IBOutlet weak var pie: PieChartView!
    
    lazy var chart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart.backgroundColor = .black
        pie.addSubview(chart)
        
        let entry1 = PieChartDataEntry(value: Double(1), label: "#1")
        let entry2 = PieChartDataEntry(value: Double(2), label: "#2")
        let entry3 = PieChartDataEntry(value: Double(3), label: "#3")
        let dataSet = PieChartDataSet(entries: [entry1, entry2, entry3, entry3, entry3, entry3, entry3, entry3, entry3, entry3], label: "Widget Types")
        let data = PieChartData(dataSet: dataSet)
        dataSet.colors = ChartColorTemplates.colorful()
        pie.data = data
        pie.chartDescription?.text = "Share of Widgets by Type"
        pie.notifyDataSetChanged()
    }
    
    
}
