import Foundation

/// The Parser class is responsible for checking if the input is valid
/// and breaking it down into separate numbers and operators.
class Parser {

    /// This function processes the input and extracts numbers and operators separately.
    /// It also validates the input to ensure it follows the correct format.
    /// Example: If the input is ["10", "+", "5"], it returns ([10, 5], ["+"])
    ///
    /// - Parameter args: The input array containing numbers and operators as strings.
    /// - Returns: A tuple with an array of integers and an array of strings (operators).
    /// - Throws: Terminates the program if the input format is incorrect.
    func parse(_ args: [String]) throws -> (numbers: [Int], operators: [String]) {
            
            /// Check if input is empty. If no arguments provided, exit the program.
            guard !args.isEmpty else {
                print("Error: No input provided.")
                exit(1)
            }

            var numbers: [Int] = [] /// Used to store the extracted numbers.
            var operators: [String] = [] /// Used to store the extracted operators.

            /// Define the set of valid operators that the calculator supports.
            let validOperators = ["+", "-", "x", "/", "%"]

            /// Process each item in the input array.
            for i in 0..<args.count {
                if i % 2 == 0 {
                    /// Expecting a number at even positions (0, 2, 4, etc.)
                    
                    /// Check if the value is a valid integer within the allowed range.
                    guard let num = Int(args[i]), num >= Int.min, num <= Int.max else {
                        print("Error: '\(args[i])' is not a valid number or is out of bounds.")
                        exit(1) /// Terminate the program if the number is invalid.
                    }
                    numbers.append(num) /// Add the valid number to the list.
                } else {
                    /// Expecting an operator at odd positions (1, 3, 5, etc.)

                    /// Check if the operator is valid.
                    guard validOperators.contains(args[i]) else {
                        print("Error: '\(args[i])' is not a valid operator.")
                        exit(1) /// Terminate if an invalid operator is found.
                    }

                    /// Prevent consecutive operators ( "++", "x /", etc.).
                    if i > 1 && validOperators.contains(args[i - 1]) {
                        print("Error: Found two operators next to each other: '\(args[i - 1]) \(args[i])'")
                        exit(1) /// Terminate if two operators appear next to each other.
                    }
                    operators.append(args[i]) /// Add the valid operator to the list.
                }
            }

            /// Make sure the input does not start or end with an operator.
            if validOperators.contains(args.first!) || validOperators.contains(args.last!) {
                print("Error: Expression cannot start or end with an operator.")
                exit(1) /// Terminate if the input starts or ends with an operator.
            }

            /// Check if the numbers and operators are in the right order.
            /// There should always be one more number than operators.
            if numbers.count != operators.count + 1 {
                print("Error: The number of values and operators is incorrect.")
                exit(1) /// Terminate if the numbers and operators are not placed correctly.
            }

            /// Return the extracted numbers and operators in separate lists.
            return (numbers, operators)
        }
}
