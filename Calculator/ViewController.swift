//
//  ViewController.swift
//  Calculator
//
//  Created by Aleksandra on 20.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var stillTyping = false
    var dotIsPlaced = false
    var firstOperand:Double = 0
    var secondOperand:Double = 0
    var operation:String = " "
    var currentInput:Double {
        get {
            return Double(resultLabel.text!)!
        }
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                resultLabel.text = "\(valueArray[0])"
            } else {
                resultLabel.text = "\(newValue)"
            }
            stillTyping = false
        }
    }

    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func numbers(_ sender: UIButton) {
        let number = sender.tag
        if stillTyping {
            resultLabel.text = resultLabel.text! + String(number)
        } else {
            resultLabel.text = String(number)
            stillTyping = true
        }
    }
    

    @IBAction func twoOperandsSingPressed(_ sender: UIButton) {
        operation = String(sender.tag)
        firstOperand = currentInput
        stillTyping = false
        dotIsPlaced = false
    }
    private func operateWithTwoOperand(operation: (Double, Double) -> Double){
        currentInput = operation(firstOperand, secondOperand)
        stillTyping = false
    }
    @IBAction func equalitySingPressed(_ sender: UIButton) {
        if stillTyping {
            secondOperand = currentInput
        }
        dotIsPlaced = false
        switch operation {
        case "13": operateWithTwoOperand {$0 / $1}
        case "14": operateWithTwoOperand {$0 * $1}
        case "15": operateWithTwoOperand {$0 - $1}
        case "16": operateWithTwoOperand {$0 + $1}
        default: break
         
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        operation = ""
        stillTyping = false
        dotIsPlaced = false
        resultLabel.text = "0"
    }

    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
        currentInput = -currentInput
    }
    @IBAction func persentButtonPressed(_ sender: UIButton) {
        if firstOperand == 0 {
            currentInput = currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
        stillTyping = false
    }
    @IBAction func squareRootButton(_ sender: UIButton) {
        currentInput = sqrt(currentInput)
    }
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if stillTyping && !dotIsPlaced {
            resultLabel.text = resultLabel.text! + "."
            dotIsPlaced = true
        } else if !stillTyping && !dotIsPlaced {
            resultLabel.text = "0."
        }
    }
}
    
