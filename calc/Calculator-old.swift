//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {
    
    var currentResult = 0;

    // Function that handles addition and subtraction operations.
    // This function processes a list of numbers and operators, performing addition and subtraction in a left-to-right order.
    // Ensures error handling and integer overflow detection.
    func addSubtract(_ numbers: [String]) -> Int {
        // Check if input is not empty.
        guard !numbers.isEmpty else {
            exit(1) // Terminate the program when imput is empty.
        }

        // Making sure that first value is an Int
        guard let firstNumber = Int(numbers[0]) else {
            exit(1) // Terminate the program if imput is not a int.
        }

        var result = firstNumber // Initialize the result variable as first number.
        var i = 1 // Supporting iterator for the numbers list.

        // Process numbers and operators in a left to right order using while loop.
        while i < numbers.count {
            let operatorSymbol = numbers[i] // Set the expected operator.
            
            // Ensure there is a valid number after the operator.
            if i + 1 < numbers.count, let num = Int(numbers[i + 1]) {
                // Addition
                if operatorSymbol == "+" {
                    // Perform addition with overflow detection.
                    let (newResult, overflow) = result.addingReportingOverflow(num)
                    if overflow { exit(1) }  // Terminate if overflows.
                    result = newResult
                }
                // Subtraction
                else if operatorSymbol == "-" {
                    // Perform subtraction with underflow detection.
                    let (newResult, overflow) = result.subtractingReportingOverflow(num)
                    if overflow { exit(1) } // Terminate if underflows.
                    result = newResult
                } else {
                    exit(1) // If the operator is neither "+" nor "-", terminate.
                }
            } else {
                exit(1) // Operator without a number
            }
            i += 2 // Move to the next operator in the sequence.
        }

        return result // Returning the computed result.
    }
    
    func multDivideModulus(_ numbers: [String]) -> Int {
        guard !numbers.isEmpty else {
            exit(1)
        }

        var processedNumbers: [String] = []
        var i = 0

        // Step 1: Process division ("/") first
        while i < numbers.count {
            if numbers[i] == "/" {
                if let last = processedNumbers.popLast(), let num1 = Int(last), i + 1 < numbers.count, let num2 = Int(numbers[i + 1]) {
                    if num2 == 0 { exit(1) } // ✅ Detects division by zero
                    processedNumbers.append(String(num1 / num2))
                    i += 1
                } else {
                    exit(1)
                }
            } else {
                processedNumbers.append(numbers[i])
            }
            i += 1
        }

        // Step 2: Process multiplication ("x") and modulus ("%") in left-to-right order
        var finalNumbers: [String] = []
        i = 0
        while i < processedNumbers.count {
            if processedNumbers[i] == "x" || processedNumbers[i] == "%" {
                if let last = finalNumbers.popLast(), let num1 = Int(last), i + 1 < processedNumbers.count, let num2 = Int(processedNumbers[i + 1]) {
                    if processedNumbers[i] == "x" {
                        let (newResult, overflow) = num1.multipliedReportingOverflow(by: num2)
                        if overflow { exit(1) } // ✅ Correctly detects multiplication overflow
                        finalNumbers.append(String(newResult))
                    } else {
                        if num2 == 0 { exit(1) } // ✅ Detects modulus by zero
                        finalNumbers.append(String(num1 % num2))
                    }
                    i += 1
                } else {
                    exit(1)
                }
            } else {
                finalNumbers.append(processedNumbers[i])
            }
            i += 1
        }

        guard let firstNumber = Int(finalNumbers[0]) else {
            exit(1)
        }

        var result = firstNumber
        i = 1

        while i < finalNumbers.count {
            let operatorSymbol = finalNumbers[i]
            if i + 1 < finalNumbers.count, let num = Int(finalNumbers[i + 1]) {
                if operatorSymbol == "+" {
                    result += num
                } else if operatorSymbol == "-" {
                    result -= num
                } else {
                    exit(1)
                }
            }
            i += 2
        }

        return result
    }
    
    func calculate(args: [String]) -> String {
        guard !args.isEmpty else {
            exit(1) // Exit if no arguments provided
        }

        // ✅ If there is only one argument, return it as-is
        if args.count == 1, let num = Int(args[0]) {
            return String(num)
        }

        let validOperators = Set(["+", "-", "x", "/", "%"])

        // Ensure no trailing operator
        if validOperators.contains(args.last!) {
            exit(1)
        }

        // Ensure valid format: alternating numbers and operators
        for (index, arg) in args.enumerated() {
            if index % 2 == 0 { // Expected a number
                if Int(arg) == nil {
                    exit(1) // Invalid number
                }
            } else { // Expected an operator
                if !validOperators.contains(arg) {
                    exit(1) // Invalid operator
                }
                if index + 1 >= args.count {
                    exit(1) // Operator at the end
                }
            }
        }

        let result: Int

        if args.contains("x") || args.contains("/") || args.contains("%") {
            result = multDivideModulus(args)
        } else if args.contains("+") || args.contains("-") {
            result = addSubtract(args)
        } else {
            exit(1) // Invalid input
        }

        return String(result)
    }
}
