/// This is the main calculator class. It calls `Parser` and `Evaluator` to perform calculations.
import Foundation

/// The main calculator class that coordinates parsing, evaluation, and error handling.
class Calculator {

    /// Create an instance of `Parser` to check if input is valid and extract numbers & operators.
    private let parser = Parser()
    
    /// Create an instance of `Evaluator` to perform calculations based on parsed input.
    private let evaluator = Evaluator()

    /// Main function that processes input and returns the final result.
    func calculate(args: [String]) -> String {
        do {
            /// Step 1: Use `Parser` to check if input is valid and extract numbers & operators.
            let (numbers, operators) = try parser.parse(args)
            
            /// Step 2: Use `Evaluator` to perform the actual calculation.
            let result = evaluator.evaluate(numbers: numbers, operators: operators)
            
            /// Step 3: Convert the numerical result to a string and return it.
            return String(result)
        } catch {
            /// If any error occurs (invalid input, division by zero, etc.), exit the program.
            exit(1)
        }
    }
}
