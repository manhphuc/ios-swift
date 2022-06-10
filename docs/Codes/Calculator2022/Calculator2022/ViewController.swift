//
//  ViewController.swift
//  Calculator2022
//
//  Created by CNTT on 3/2/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var calculatorDisplay: UILabel!
    var isTyping = false
    
    //MARK: User's Functions Definiton
    @IBAction func digitButtonPocessing(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let calculatorDisplayValue = calculatorDisplay.text!
        
        if !isTyping {
            if digit != "0" {
                calculatorDisplay.text = digit
                isTyping = true
            }
        }
        else {
            calculatorDisplay.text = calculatorDisplayValue + digit
        }
    }
    
    // Calculated variable Definition
    private var displayDoubleValue:Double {
        get {
            return Double(calculatorDisplay.text!)!
        }
        set {
            calculatorDisplay.text = String(newValue)
        }
    }
    // Create CalculatorBrain Object
    let calculatorBrain = CalculatoBrain()
    
    @IBAction func functionButtonProcessing(_ sender: UIButton) {
        isTyping = false
        let matSymbol = sender.currentTitle!
        calculatorBrain.setOperand(displayDoubleValue)
        calculatorBrain.performFunctions(matSymbol)
        displayDoubleValue = calculatorBrain.result
    }
}

