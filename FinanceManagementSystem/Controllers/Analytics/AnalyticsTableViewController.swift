//
//  AnalyticsTableViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/14/20.
//

import UIKit
import Charts

class AnalyticsTableViewController: UITableViewController {
    
    @IBOutlet weak var lineChartForIncome: LineChartView!
    @IBOutlet weak var piechartForIncome: PieChartView!
    @IBOutlet weak var pieChartForExpense: PieChartView!
    @IBOutlet weak var lineChartForExpense: LineChartView!
    @IBOutlet weak var analyticDateFrom: UIDatePicker!
    @IBOutlet weak var analyticdateTo: UIDatePicker!
    
    
    var model = Model()
    var array = [ChartDataEntry]()
    var arrayForExpensePieChart = [ChartDataEntry]()
    var lineChartValues = [ChartDataEntry]()
    var dateArray = [String]()
    var sum = [Double]()
    var dateArrayForExpense = [String]()
    var sumForExpense = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        analyticDateFrom.setDate(Date().addingTimeInterval((-24*60*60) * 30), animated: true)
        
        let urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_categories")!
        let urlStringForGraphOfIncome = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_graphs")!
        let urlStringForExpensePieChart = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_categories")!
        let urlStringForGraphOfExpense = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_graphs")!
        tableView.delegate = self
        tableView.dataSource = self
        
        model.getAnalyticsForExpenseGrapghic(urlString: urlStringForGraphOfExpense) {
            DispatchQueue.main.async {
                for index in 0..<self.model.analyticsForExpenseGraph.count {
                    self.dateArrayForExpense.append(self.model.analyticsForExpenseGraph[index].data)
                    self.sumForExpense.append(self.model.analyticsForExpenseGraph[index].sumOfTransaction)
                    
                    
                }
                self.setChartForExpense(date: self.dateArrayForExpense, sum: self.sumForExpense)
            }
        }
        
        model.getAnalyticsForIncomeGrapghic(urlString: urlStringForGraphOfIncome) {
            DispatchQueue.main.async {
                for index in 0..<self.model.analyticsForIncomeGraph.count {
                    
                    self.dateArray.append(self.model.analyticsForIncomeGraph[index].data)
                    self.sum.append(self.model.analyticsForIncomeGraph[index].sumOfTransaction)
                    
                    
                }
                self.setChart(date: self.dateArray, sum: self.sum)
            }
        }
        
        
        model.getAnalyticsForExpenseCat(urlString: urlStringForExpensePieChart) {
            DispatchQueue.main.async {
                
                for index in 0..<self.model.analyticsForExpense.count {
                    let entry1 = PieChartDataEntry(value: self.model.analyticsForExpense[index].sum ?? 0.0, label: self.model.analyticsForExpense[index].name ?? "")
                    self.arrayForExpensePieChart.append(entry1)
                }
                
                let dataSet = PieChartDataSet(entries: self.arrayForExpensePieChart, label: "Категории")
                let data = PieChartData(dataSet: dataSet)
                // dataSet.entryLabelColor = .black
                dataSet.setColor(.black, alpha: 1.0)
                dataSet.colors = ChartColorTemplates.colorful()
                dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice
                dataSet.valueFont = UIFont(name: "Roboto-Regular", size: 9) ?? UIFont()
                dataSet.valueColors = [UIColor.black]
                self.pieChartForExpense.data = data
                
                self.pieChartForExpense.legend.formSize = 4
                self.pieChartForExpense.entryLabelColor = .black
                self.pieChartForExpense.entryLabelFont = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.pieChartForExpense.legend.font = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.pieChartForExpense.chartDescription?.text = "Категории расходов"
                self.pieChartForExpense.holeColor = .white
                self.pieChartForExpense.notifyDataSetChanged()
            }
        }
        
        model.getAnalyticsForIncomeCat(urlString: urlString) {
            DispatchQueue.main.async {
                
                for index in 0..<self.model.analyticsForIncome.count {
                    let entry1 = PieChartDataEntry(value: self.model.analyticsForIncome[index].sum, label: self.model.analyticsForIncome[index].name)
                    self.array.append(entry1)
                }
                
                let dataSet = PieChartDataSet(entries: self.array, label: "Категории")
                let data = PieChartData(dataSet: dataSet)
                dataSet.colors = ChartColorTemplates.colorful()
                dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice
                dataSet.valueFont = UIFont(name: "Roboto-Regular", size: 9) ?? UIFont()
                dataSet.valueColors = [UIColor.black]
                
                self.piechartForIncome.data = data
                
                self.piechartForIncome.legend.formSize = 4
                self.piechartForIncome.entryLabelColor = .black
                self.piechartForIncome.noDataText = "За этот период данных нет"
                self.piechartForIncome.noDataTextColor = .black
                
                self.piechartForIncome.chartDescription?.font = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.piechartForIncome.entryLabelFont = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.piechartForIncome.legend.font = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.piechartForIncome.holeColor = .white
                self.piechartForIncome.chartDescription?.text = "Категории дохода"
                self.piechartForIncome.notifyDataSetChanged()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
        header.textLabel?.font = UIFont(name: "Roboto-Regular.ttf", size: 18)
        //header.textLabel?.text = "About Us"
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = NSTextAlignment.left
    }
    
    
    
    
    func setChartForExpense(date: [String], sum: [Double]) {
        lineChartForExpense.rightAxis.enabled = false
        let xAxis = lineChartForExpense.xAxis
        let yAxis = lineChartForExpense.leftAxis
        
        xAxis.labelFont = .systemFont(ofSize: 8)
        yAxis.labelFont = .systemFont(ofSize: 8)
        
        xAxis.setLabelCount(3, force: false)
        
        xAxis.labelPosition = .bottom
        for i in 0..<sum.count {
            print("HERE IT IS \(sum[i])")
        }
        
        lineChartForExpense.setBarChartData(xValues: date, yValues: sum, label: "Расход")
    }
    
    func setChart(date: [String], sum: [Double]) {
        lineChartForIncome.rightAxis.enabled = false
        let xAxis = lineChartForIncome.xAxis
        let yAxis = lineChartForIncome.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 8)
        xAxis.labelFont = .systemFont(ofSize: 8)
        
        xAxis.setLabelCount(3, force: false)
        xAxis.labelPosition = .bottom
        
        lineChartForIncome.setBarChartData(xValues: date, yValues: sum, label: "Доход")
    }
    
    let dateFormatter = DateFormatter()
    func getDateForLineChartIncome() {
        lineChartValues = []
        dateArray = []
        sum = []
        model.analyticsForIncomeGraph = []
        lineChartForIncome.clearValues()
        var urlStringForGraphOfIncome = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_graphs")!
        
        urlStringForGraphOfIncome.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForGraphOfIncome.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: analyticDateFrom.date))"))
        urlStringForGraphOfIncome.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: analyticdateTo.date))"))
        
        model.getAnalyticsForIncomeGrapghic(urlString: urlStringForGraphOfIncome) {
            self.dateArray = []
            self.sum = []
            DispatchQueue.main.async {
                for index in 0..<self.model.analyticsForIncomeGraph.count {
                    self.dateArray.append(self.model.analyticsForIncomeGraph[index].data)
                    self.sum.append(self.model.analyticsForIncomeGraph[index].sumOfTransaction)
                    
                    
                }
                self.setChart(date: self.dateArray, sum: self.sum)
            }
        }
    }
    
    func getDataForPieChartExpense() {
        arrayForExpensePieChart = []
        model.analyticsForExpense = []
        self.pieChartForExpense.clear()
        var urlStringForExpenses = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_categories")!
        urlStringForExpenses.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForExpenses.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: analyticDateFrom.date))"))
        urlStringForExpenses.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: analyticdateTo.date))"))
        
        model.getAnalyticsForExpenseCat(urlString: urlStringForExpenses) {
            DispatchQueue.main.async {
                
                for index in 0..<self.model.analyticsForExpense.count {
                    let entry1 = PieChartDataEntry(value: self.model.analyticsForExpense[index].sum ?? 0.0, label: self.model.analyticsForExpense[index].name ?? "")
                    self.arrayForExpensePieChart.append(entry1)
                }
                
                let dataSet = PieChartDataSet(entries: self.arrayForExpensePieChart, label: "Категории")
                let data = PieChartData(dataSet: dataSet)
                dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice
                dataSet.valueFont = UIFont(name: "Roboto-Regular", size: 9) ?? UIFont()
                dataSet.valueColors = [UIColor.black]
                dataSet.colors = ChartColorTemplates.colorful()
                dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice
                self.pieChartForExpense.data = data
                self.pieChartForExpense.chartDescription?.text = "Категории расходов"
                self.pieChartForExpense.notifyDataSetChanged()
            }
        }
        
    }
    
    func getDataForLineChartExpense() {
        self.dateArrayForExpense = []
        self.sumForExpense = []
        lineChartValues = []
        model.analyticsForExpenseGraph = []
        lineChartForExpense.clearValues()
        var urlStringForGraphOfExpense = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_graphs")!
        
        urlStringForGraphOfExpense.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForGraphOfExpense.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: analyticDateFrom.date))"))
        urlStringForGraphOfExpense.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: analyticdateTo.date))"))
        
        model.getAnalyticsForExpenseGrapghic(urlString: urlStringForGraphOfExpense) {
            DispatchQueue.main.async {
                for index in 0..<self.model.analyticsForExpenseGraph.count {
                    self.dateArrayForExpense.append(self.model.analyticsForExpenseGraph[index].data)
                    self.sumForExpense.append(self.model.analyticsForExpenseGraph[index].sumOfTransaction)
                    
                    
                }
                self.setChartForExpense(date: self.dateArrayForExpense, sum: self.sumForExpense)
            }
        }
    }
    
    func getDataForPieChartIncome() {
        array = []
        model.analyticsForIncome = []
        self.piechartForIncome.clear()
        var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_categories")!
        urlString.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlString.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: analyticDateFrom.date))"))
        urlString.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: analyticdateTo.date))"))
        
        model.getAnalyticsForIncomeCat(urlString: urlString) {
            DispatchQueue.main.async {
                
                for index in 0..<self.model.analyticsForIncome.count {
                    let entry1 = PieChartDataEntry(value: self.model.analyticsForIncome[index].sum, label: self.model.analyticsForIncome[index].name)
                    self.array.append(entry1)
                }
                let dataSet = PieChartDataSet(entries: self.array, label: "Категории")
                let data = PieChartData(dataSet: dataSet)
                dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice
                dataSet.valueFont = UIFont(name: "Roboto-Regular", size: 9) ?? UIFont()
                dataSet.valueColors = [UIColor.black]
                dataSet.colors = ChartColorTemplates.colorful()
                self.piechartForIncome.data = data
                self.piechartForIncome.chartDescription?.text = "Категории дохода"
                self.piechartForIncome.notifyDataSetChanged()
            }
            
        }
    }
    
    
    @IBAction func analyticDateFromPressed(_ sender: Any) {
        getDataForPieChartIncome()
        getDateForLineChartIncome()
        getDataForPieChartExpense()
        getDataForLineChartExpense()
    }
    
    @IBAction func analyticDateToPressed(_ sender: Any) {
        getDataForPieChartIncome()
        getDateForLineChartIncome()
        getDataForPieChartExpense()
        getDataForLineChartExpense()
    }
    
}

extension LineChartView {
    
    private class LineChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            //print("HERE IT IS THE COUNT OF LABEL \(value)")
            if value == -value {
                
            } else {
                return labels[Int((value))]
            }
            return ""
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: yValues[i])
            print(yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: label)
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .cubicBezier
        chartDataSet.fill = Fill(color: UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1))
        chartDataSet.setColor(UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1))
        chartDataSet.fillAlpha = 0.8
        chartDataSet.drawFilledEnabled = true
        
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        
        let chartFormatter = LineChartFormatter(labels: xValues)
        let xAxis = XAxis()
        
        
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}

