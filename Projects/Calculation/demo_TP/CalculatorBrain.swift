//
//  CalculatorBrain.swift
//  demo_TP
//
//  Created by CNTT on 3/8/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import UIKit

func sign(_ a:Double)->Double{
    return -a
}
func add(_ a:Double,_ b:Double)->Double{
    return a + b;
}
func sub(_ a:Double,_ b:Double)->Double{
    return a - b;
}
func mul(_ a:Double,_ b:Double)->Double{
    return a * b;
}
func div(_ a:Double,_ b:Double)->Double{
    return a / b;
}

struct PendingCalculator{
    let firstOperator:Double
    let function:(Double,Double)->Double
}

class CalculatorBrain {
    
    //MARK: Propeties
    private var accumlator:Double?
    
    enum OperatorType {
        case constant(Double)
        case unaryOperator((Double)->Double)
        case binaryOperator((Double,Double)->Double)
        case equal
    }
    
    private let operators:[String:OperatorType] = [
        "e"     : .constant( M_E ),
        "∏"     : .constant( Double.pi ),
        "√"     : .unaryOperator( sqrt ),
        "Cos"   : .unaryOperator( cos ),
        "±"     : .unaryOperator( sign ),
        "/"     : .binaryOperator( div ),
        "+"     : .binaryOperator( add ),
        "-"     : .binaryOperator( sub ),
        "*"     : .binaryOperator( mul ),
        "="     : .equal
    ]
    
    //MARK: class's Methods
    func setOperand(_ operand:Double) {
        accumlator = operand
    }
    
    var pendingCalculator:PendingCalculator?
    
    func performFunctions(_ mathSynbol:String) {
        if let operatorsType = operators[mathSynbol]{
            //accumlator = value
            switch operatorsType{
            case .constant(let value):
                accumlator = value
            case .unaryOperator(let function):
                if let value = accumlator{
                    accumlator = function(value)
                }
            case .binaryOperator(let binaryFunction):
                if let value = accumlator {
                    pendingCalculator = PendingCalculator(firstOperator: value, function: binaryFunction)
                    accumlator = nil
                }
            case .equal:
                if let pendingCalculator = pendingCalculator{
                    if let value = accumlator{
                        accumlator = pendingCalculator.function(pendingCalculator.firstOperator,value)
                    }
                   self.pendingCalculator = nil
                }
            }
        }
        
//        switch mathSynbol {
//    case "e":
//        accumlator = M_E
//    case "∏":
//        accumlator = Double.pi
//    case "√":
//        if let operand = accumlator {
//            accumlator = sqrt(operand)
//            }
//    case "Cos":
//        if let operand = accumlator {
//            accumlator = cos(operand)
//            }
//    case "Sin":
//        if let operand = accumlator {
//            accumlator = sin(operand)
//            }
//    default:
//        break
//        }
    }
    
    public var result:Double?{
        get {
            return accumlator
        }
    }
}

