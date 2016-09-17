//
//  ViewController.swift
//  Calculator
//
//  Created by rutmb on 17.09.16.
//  Copyright © 2016 rutmb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet private weak var displayLabel: UILabel!
  
  private var brain = CalculatorBrain()
  private var isUserInTheMiddleOfTyping = false
  private var displayValue: Double {
    set {
      displayLabel.text = String(newValue)
    }
    get {
      return Double(displayLabel.text!)!
    }
  }
  
  @IBAction private func tapDigitAction(sender: UIButton) {
    let digitTitle = sender.currentTitle!
    
    if isUserInTheMiddleOfTyping {
      let currentDisplayText = displayLabel.text!
      displayLabel.text = currentDisplayText + digitTitle
    } else {
      displayLabel.text = digitTitle
    }
    isUserInTheMiddleOfTyping = true
  }
  
  @IBAction private func perfomOperationAction(sender: UIButton) {
    if isUserInTheMiddleOfTyping {
      brain.setOperand(displayValue)
      isUserInTheMiddleOfTyping = false
    }
    
    if let mathematicSymbol = sender.currentTitle {
      brain.performOperation(mathematicSymbol)
    }
    displayValue = brain.result
  }
}

