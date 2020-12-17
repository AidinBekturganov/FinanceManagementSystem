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
    @IBOutlet weak var dateFromGrapghOfExpense: UIDatePicker!
    @IBOutlet weak var dateFromForPieChart: UIDatePicker!
    @IBOutlet weak var dateToPieChartExpense: UIDatePicker!
    @IBOutlet weak var dateToGrapghOfExpense: UIDatePicker!
    @IBOutlet weak var lineChartForExpense: LineChartView!
    @IBOutlet weak var dateToForGrapghOfIncome: UIDatePicker!
    @IBOutlet weak var dateFrom: UIDatePicker!
    @IBOutlet weak var dateFromForGraphOfIncome: UIDatePicker!
    @IBOutlet weak var dateTo: UIDatePicker!
    
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
        
        let urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_categories")!
        let urlStringForGraphOfIncome = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_graphs")!
        let urlStringForExpensePieChart = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_categories")!
        let urlStringForGraphOfExpense = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_graphs")!
        self.piechartForIncome.backgroundColor = UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1)
        self.pieChartForExpense.backgroundColor = UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1)
        self.lineChartForIncome.backgroundColor = UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1)
        self.lineChartForExpense.backgroundColor = UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1)

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
                dataSet.colors = ChartColorTemplates.colorful()
                self.pieChartForExpense.data = data
                self.pieChartForExpense.legend.formSize = 4
                self.pieChartForExpense.entryLabelFont = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.pieChartForExpense.legend.font = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.pieChartForExpense.chartDescription?.text = "Категории расходов"
                self.pieChartForExpense.holeColor = UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1)
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
                self.piechartForIncome.data = data
                self.piechartForIncome.legend.formSize = 4
                self.piechartForIncome.chartDescription?.font = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.piechartForIncome.entryLabelFont = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.piechartForIncome.legend.font = UIFont(name: "Roboto-Regular", size: 7) ?? UIFont()
                self.piechartForIncome.chartDescription?.text = "Категории дохода"
                self.piechartForIncome.notifyDataSetChanged()
            }
        }
        
        
        

    }
    
    func setChartForExpense(date: [String], sum: [Double]) {
        lineChartForExpense.rightAxis.enabled = false
        let xAxis = lineChartForExpense.xAxis
        xAxis.labelFont = .systemFont(ofSize: 6)
        
        xAxis.setLabelCount(1, force: false)
        xAxis.labelPosition = .bottom
        for i in 0..<sum.count {
            print("HERE IT IS \(sum[i])")
        }
        
        lineChartForExpense.setBarChartData(xValues: date, yValues: sum, label: "Расход")
    }
    
    func setChart(date: [String], sum: [Double]) {
        lineChartForIncome.rightAxis.enabled = false
        let xAxis = lineChartForIncome.xAxis
        xAxis.labelFont = .systemFont(ofSize: 6)
        
        xAxis.setLabelCount(1, force: false)
        xAxis.labelPosition = .bottom
        
        lineChartForIncome.setBarChartData(xValues: date, yValues: sum, label: "Доход")
    }
    
    let dateFormatter = DateFormatter()
    
    @IBAction func dateToGraphIncomePressed(_ sender: Any) {
        lineChartValues = []
//        dateArray = []
//        sum = []
        model.analyticsForIncomeGraph = []
        lineChartForIncome.clearValues()
        var urlStringForGraphOfIncome = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_graphs")!
        
        urlStringForGraphOfIncome.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForGraphOfIncome.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: dateFromForGraphOfIncome.date))"))
        urlStringForGraphOfIncome.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: dateToForGrapghOfIncome.date))"))
       
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
    
    
    @IBAction func dateGraphIncomePressed(_ sender: Any) {
        lineChartValues = []
//        dateArray = []
//        sum = []
        model.analyticsForIncomeGraph = []
        lineChartForIncome.clearValues()
        var urlStringForGraphOfIncome = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_graphs")!
        
        urlStringForGraphOfIncome.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForGraphOfIncome.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: dateFromForGraphOfIncome.date))"))
        urlStringForGraphOfIncome.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: dateToForGrapghOfIncome.date))"))
       
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
    
    
    @IBAction func dateFromIncomAnal(_ sender: Any) {
        array = []
        model.analyticsForIncome = []
        self.piechartForIncome.clear()
        var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_categories")!
        urlString.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlString.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: dateFrom.date))"))
        urlString.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: dateTo.date))"))
        
        model.getAnalyticsForIncomeCat(urlString: urlString) {
            DispatchQueue.main.async {
                
                for index in 0..<self.model.analyticsForIncome.count {
                    let entry1 = PieChartDataEntry(value: self.model.analyticsForIncome[index].sum, label: self.model.analyticsForIncome[index].name)
                    self.array.append(entry1)
                }
                
                let dataSet = PieChartDataSet(entries: self.array, label: "Категории")
                let data = PieChartData(dataSet: dataSet)
                dataSet.colors = ChartColorTemplates.colorful()
                self.piechartForIncome.data = data
                self.piechartForIncome.chartDescription?.text = "Категории дохода"

                //All other additions to this function will go here

                //This must stay at end of function
                self.piechartForIncome.notifyDataSetChanged()
            }
           
        }
        
    }
    @IBAction func dateToPieChartExpense(_ sender: Any) {
        arrayForExpensePieChart = []
        model.analyticsForExpense = []
        self.pieChartForExpense.clear()
        var urlStringForExpenses = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_categories")!
        urlStringForExpenses.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForExpenses.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: dateFromForPieChart.date))"))
        urlStringForExpenses.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: dateToPieChartExpense.date))"))
        
        model.getAnalyticsForExpenseCat(urlString: urlStringForExpenses) {
            DispatchQueue.main.async {
                
                for index in 0..<self.model.analyticsForExpense.count {
                    let entry1 = PieChartDataEntry(value: self.model.analyticsForExpense[index].sum ?? 0.0, label: self.model.analyticsForExpense[index].name ?? "")
                    self.arrayForExpensePieChart.append(entry1)
                }
                
                let dataSet = PieChartDataSet(entries: self.arrayForExpensePieChart, label: "Категории")
                let data = PieChartData(dataSet: dataSet)
                dataSet.colors = ChartColorTemplates.colorful()
                self.pieChartForExpense.data = data
                self.pieChartForExpense.chartDescription?.text = "Категории расходов"
                self.pieChartForExpense.notifyDataSetChanged()
            }
        }
    }
    
    @IBAction func dateFromToExpensePressed(_ sender: Any) {
        dateArrayForExpense = []
        sumForExpense = []
        lineChartValues = []
        model.analyticsForExpenseGraph = []
        lineChartForExpense.clearValues()
        var urlStringForGraphOfExpense = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_graphs")!
        
        urlStringForGraphOfExpense.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForGraphOfExpense.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: dateFromGrapghOfExpense.date))"))
        urlStringForGraphOfExpense.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: dateToGrapghOfExpense.date))"))
       
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
    
    @IBAction func datefromPieChartExpense(_ sender: Any) {
        arrayForExpensePieChart = []
        model.analyticsForExpense = []
        self.pieChartForExpense.clear()
        var urlStringForExpenses = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_categories")!
        urlStringForExpenses.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForExpenses.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: dateFromForPieChart.date))"))
        urlStringForExpenses.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: dateToPieChartExpense.date))"))
        
        model.getAnalyticsForExpenseCat(urlString: urlStringForExpenses) {
            DispatchQueue.main.async {
                
                for index in 0..<self.model.analyticsForExpense.count {
                    let entry1 = PieChartDataEntry(value: self.model.analyticsForExpense[index].sum ?? 0.0, label: self.model.analyticsForExpense[index].name ?? "")
                    self.arrayForExpensePieChart.append(entry1)
                }
                
                let dataSet = PieChartDataSet(entries: self.arrayForExpensePieChart, label: "Категории")
                let data = PieChartData(dataSet: dataSet)
                dataSet.colors = ChartColorTemplates.colorful()
                self.pieChartForExpense.data = data
                self.pieChartForExpense.chartDescription?.text = "Категории расходов"
                self.pieChartForExpense.notifyDataSetChanged()
            }
        }
    }
    
    @IBAction func dateFromGrapghExpensePressed(_ sender: Any) {
        self.dateArrayForExpense = []
        self.sumForExpense = []
        lineChartValues = []
        model.analyticsForExpenseGraph = []
        lineChartForExpense.clearValues()
        var urlStringForGraphOfExpense = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/expenses_graphs")!
        
        urlStringForGraphOfExpense.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlStringForGraphOfExpense.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: dateFromGrapghOfExpense.date))"))
        urlStringForGraphOfExpense.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: dateToGrapghOfExpense.date))"))
       
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
    
    @IBAction func dateToIncomeAnal(_ sender: Any) {
        array = []
        model.analyticsForIncome = []
        self.piechartForIncome.clear()
        var urlString = URLComponents(string: "https://fms-neobis.herokuapp.com/analytics/incomes_categories")!
        urlString.queryItems = []
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        urlString.queryItems?.append(URLQueryItem(name: "fromDate", value: "\(dateFormatter.string(from: dateFrom.date))"))
        urlString.queryItems?.append(URLQueryItem(name: "toDate", value: "\(dateFormatter.string(from: dateTo.date))"))
        
        model.getAnalyticsForIncomeCat(urlString: urlString) {
            DispatchQueue.main.async {
                
                for index in 0..<self.model.analyticsForIncome.count {
                    let entry1 = PieChartDataEntry(value: self.model.analyticsForIncome[index].sum, label: self.model.analyticsForIncome[index].name)
                    //print("HERE IT IS \(self.model.analyticsForIncome[index].sum)")
                    self.array.append(entry1)
                }
                let dataSet = PieChartDataSet(entries: self.array, label: "Категории")
                let data = PieChartData(dataSet: dataSet)
                dataSet.colors = ChartColorTemplates.colorful()
                self.piechartForIncome.data = data
                self.piechartForIncome.chartDescription?.text = "Категории дохода"

                //All other additions to this function will go here

                //This must stay at end of function
                self.piechartForIncome.notifyDataSetChanged()
            }
           
        }
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
        chartDataSet.fill = Fill(color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        chartDataSet.setColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
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
