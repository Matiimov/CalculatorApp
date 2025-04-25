import Foundation

var args = ProcessInfo.processInfo.arguments
args.removeFirst() /// remove the name of the program

/// Initialize a Calculator object
let calculator = Calculator();

/// Calculate the result
let result = calculator.calculate(args: args) /// Pass arguments

print(result)
