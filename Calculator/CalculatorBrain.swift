//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by rutmb on 17.09.16.
//  Copyright © 2016 rutmb. All rights reserved.
//

import Foundation

enum Optional<T> {
  case None
  case Some(T)
}

class CalculatorBrain {
  
  private enum Operation {
    case Constant(Double)
    case UnaryOperation((Double) -> Double)
    case BinaryOperation((Double, Double) -> Double)
    case Equals
  }
  
  private var accumulator = 0.0
  private var pending: PendingBinaryOperationInfo?
  
  private var operations: Dictionary <String, Operation> = [
    "π": Operation.Constant(M_PI),
    "℮": Operation.Constant(M_E),
    "√": Operation.UnaryOperation(sqrt),
    "cos": Operation.UnaryOperation(cos),
    "×": Operation.BinaryOperation({ $0 * $1}),
    "÷": Operation.BinaryOperation({ $0 / $1}),
    "−": Operation.BinaryOperation({ $0 - $1}),
    "+": Operation.BinaryOperation({ $0 + $1}),
    "=": Operation.Equals,
    "±": Operation.UnaryOperation({-$0})
  ]
  
  private func executePendingBinaryOperation() {
    if pending != nil {
      accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
      pending = nil
    }
  }
  
  private struct PendingBinaryOperationInfo {
    var binaryFunction: (Double, Double) -> Double
    var firstOperand: Double
  }
  
  func setOperand(operand: Double) {
    accumulator = operand
  }
  
  func performOperation (symbol: String) {
    if let operation = operations[symbol] {
      switch operation {
      case .Constant (let value):
        accumulator = value
      case .UnaryOperation (let function):
        accumulator =  function(accumulator)
      case .BinaryOperation (let function):
        executePendingBinaryOperation()
        pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
      case .Equals:
        executePendingBinaryOperation()
      }
    }
  }
  
  var result: Double {
    get {
      return accumulator
    }
  }
}