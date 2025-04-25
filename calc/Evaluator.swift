import Foundation

/// The `Evaluator` class is responsible for performing the actual calculations.
/// It takes two numbers and an operator, then applies the correct mathematical operation.
/// It also ensures that errors like division by zero and integer overflow are properly handled.
class Evaluator {
    
    /// This function performs basic arithmetic operations: `+`, `-`, `x`, `/`, `%`.
    ///
    /// - Parameters:
    ///   - num1: The first number in the operation.
    ///   - num2: The second number in the operation.
    ///   - operation: The operator (e.g., `"+"`, `"-"`, `"x"`, `"/"`, `"%"`).
    /// - Returns: The result of the computation.
    ///
    /// - Important:
    ///   - If an invalid operator is provided, the program exits with an error.
    ///   - If an overflow occurs during addition, subtraction, or multiplication, the program exits.
    ///   - If a division by zero or modulus by zero occurs, the program exits.
    func compute(_ num1: Int, _ num2: Int, _ operation: String) -> Int {
        switch operation {
        case "+": /// **Addition**
            let (result, overflow) = num1.addingReportingOverflow(num2) /// Safely adds two numbers
            if overflow { /// Detects integer overflow
                print("Error: Integer overflow occurred during addition.")
                exit(1)
            }
            return result
            
        case "-": /// **Subtraction**
            let (result, overflow) = num1.subtractingReportingOverflow(num2) /// Prerorm Subtraction
            if overflow { /// Detects integer overflow
                print("Error: Integer underflow occurred during subtraction.")
                exit(1)
            }
            return result
            
        case "x": /// **Multiplication**
            let (result, overflow) = num1.multipliedReportingOverflow(by: num2) /// Perform multiplication
            if overflow { /// Detects multiplication overflow
                print("Error: Integer overflow occurred during multiplication.")
                exit(1)
            }
            return result
            
        case "/": /// **Division**
            if num2 == 0 { /// Prevents division by zero
                print("Error: Division by zero is not allowed.")
                exit(1)
            }
            return num1 / num2 /// Preform division
            
        case "%": /// **Modulus**
            if num2 == 0 { /// Prevents modulus by zero
                print("Error: Modulus by zero is not allowed.")
                exit(1)
            }
            return num1 % num2 /// Returns remainder after performing division
            
        default:
            print("Error: Invalid operator '\(operation)' used.")
            exit(1)  /// Exit if an invalid operator is used
        }
    }
    
    /// Calculates the result while making sure multiplication and division happen before addition and subtraction.
    ///
    /// - Parameters:
    ///   - numbers: An array of integers.
    ///   - operators: An array of strings representing operators (`+`, `-`, `x`, `/`, `%`).
    /// - Returns: The computed result.
    ///
    /// - Note:
    ///   - The function first processes multiplication (`x`), division (`/`), and modulus (`%`).
    ///   - Then, it processes addition (`+`) and subtraction (`-`).
    ///   - This ensures that operations are handled in the correct order.
    func evaluate(numbers: [Int], operators: [String]) -> Int {
        var result = numbers[0] // Start with the first number in the list
        
        /// **Step 1: Handle multiplication (x), division (/), and modulus (%) first**
        var tempNumbers: [Int] = [result] /// Starts with the first number
        var tempOperators: [String] = [] /// Used to store only "+" and "-" operators
        
        /// Loop through all operators and process them
        for i in 0..<operators.count {
            let op = operators[i] /// Current operator
            let nextNumber = numbers[i + 1] /// The number that follows the current operator
            
            /// If it's multiplication, division, or modulus, compute immediately
            if op == "x" || op == "/" || op == "%" {
                let lastNumber = tempNumbers.removeLast() /// Get the last number
                let newResult = compute(lastNumber, nextNumber, op) /// Perform operation
                tempNumbers.append(newResult) /// Store the new computed value
            } else {
                /// If it's "+" or "-", keep it for later processing
                tempNumbers.append(nextNumber)
                tempOperators.append(op)
            }
        }
        
        /// **Step 2: Handle addition (+) and subtraction (-) from left to right**
        result = tempNumbers[0] /// Start with the first number as the initial result
        
        /// Iterate through the remaining operators and numbers
        for i in 0..<tempOperators.count {
            let nextNumber = tempNumbers[i + 1] /// Get the next number in sequence
            let op = tempOperators[i] /// Get the corresponding operator

            /// Perform the calculation based on the current operator
            result = compute(result, nextNumber, op)
        }
        
        return result /// Return the final result
    }
}
