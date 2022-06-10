//
//  CalculatorBrain.swift
//  Calculator2022
//
//  Created by CNTT on 3/9/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import UIKit

class CalculatoBrain {
    private var accumulator: Double
    
    func setOperand(<#parameters#>) -> <#return type#> {
        <#function body#>
    }
    func performFunctions(<#parameters#>) -> <#return type#> {
        switch matSymbol {
        case "e":
            displayDoubleValue = M_E
        case "∏":
            displayDoubleValue = Double.pi
        case "√":
            displayDoubleValue = sqrt(displayDoubleValue)
        case "cos":
            displayDoubleValue = cos(displayDoubleValue)
        default:
            break
        }
    }
    
    public var result:Double {
        get {
            
        }
        set {
            
        }
    }
}
