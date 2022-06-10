//
//  ViewController.swift
//  demo_TP
//
//  Created by CNTT on 3/1/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var calculatorDisplay: UILabel!
    var isTyping = false
    
    //MARK: User's funtion Definiton
    @IBAction func digitButtonProessing(_ sender: UIButton) {
        //print(sender.currentTitle!)
        let digit = sender.currentTitle!
        let currentDisplayValue = calculatorDisplay.text!
        
        if !isTyping {
            if digit != "0"{
                calculatorDisplay.text = digit
                isTyping = true
            }
        }
        else {
            calculatorDisplay.text = currentDisplayValue + digit
        }
    }
    
    //Calculated variablle Definition
    private var displayDoubleValue:Double {
        get {
            return Double(calculatorDisplay.text!)!
        }
        set {
            calculatorDisplay.text = String(format: "%0.12f", newValue)
        }
    }
    
    //Calcula  rain object
    private let calculatorBrant = CalculatorBrain()
    
    @IBAction func calculatorButtonProessing(_ sender: UIButton) {
        if isTyping{
            isTyping = false
            calculatorBrant.setOperand(displayDoubleValue)
        }
        let mathSynbol = sender.currentTitle!
        calculatorBrant.performFunctions(mathSynbol)
        if let result = calculatorBrant.result {
            displayDoubleValue = result
        }
    }
    
}


