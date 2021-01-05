//
//  MainTransactionsViewController.swift
//  FinanceManagementSystem
//
//  Created by User on 12/11/20.
//

import UIKit

class MainTransactionsViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private lazy var incomeView = IncomeViewController()
    private lazy var expenseView = ExpenseViewController()
    private lazy var transferView = TransferViewController()
    
    @IBOutlet weak var test: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.test.alpha = 0
            self.view3.alpha = 1
            self.view2.alpha = 0
        })
    }
    
    private func create() {
        addChild(incomeView)
        addChild(expenseView)
        addChild(transferView)
        
        self.view.addSubview(incomeView.view)
        self.view.addSubview(expenseView.view)
        self.view.addSubview(transferView.view)
        
        incomeView.didMove(toParent: self)
        expenseView.didMove(toParent: self)
        transferView.didMove(toParent: self)
        
        incomeView.view.frame = self.view.bounds
        expenseView.view.frame = self.view.bounds
        transferView.view.frame = self.view.bounds
        
        expenseView.view.isHidden = true
        transferView.view.isHidden = true
        
    }
    
    
    @IBAction func didTapSegment(segment: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.test.alpha = 0
                self.view3.alpha = 1
                self.view2.alpha = 0
            })
        } else if segmentControl.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.test.alpha = 0
                self.view3.alpha = 0
                self.view2.alpha = 1
            })
        } else if segmentControl.selectedSegmentIndex == 2 {
            UIView.animate(withDuration: 0.5, animations: {
                self.test.alpha = 1
                self.view3.alpha = 0
                self.view2.alpha = 0
            })
        }
    }
}



