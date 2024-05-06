import 'dart:math';

import 'package:math_expressions/math_expressions.dart';

void handleButtonAction(String value, String text, Function(String) setText) {
  switch (value) {
    case "CE":
      setText(""); // Clear the entire field
      break;
    case "D":
      if (text.isNotEmpty) {
        setText(
            text.substring(0, text.length - 1)); // Delete the last character
      }
      break;
    case "=":
      try {
        double result = double.parse(evaluate(text));
        String formattedResult = result.toString();
        if (formattedResult.contains('.')) {
          // Если есть точка, выводим цифры после нее
          setText(formattedResult);
        } else {
          // Если нет точки, выводим столько знаков, сколько есть после запятой, но не больше 15
          int decimalPlaces = formattedResult.split('.')[1].length;
          decimalPlaces = min(decimalPlaces, 15);
          setText(result.toStringAsFixed(decimalPlaces));
        }
      } catch (e) {
        setText(
            "Error"); // Display an error message if the expression is invalid
      }
      break;
    case "√": // Handle the square root button
      setText(text + "sqrt("); // Add the square root symbol to the text
      break;
    case "sin":
      setText(text + "sin(");
      break;
    case "cos":
      setText(text + "cos(");
      break;
    case "tan":
      setText(text + "tan(");
      break;
    case "arcsin":
      setText(text + "asin(");
      break;
    case "arccos":
      setText(text + "acos(");
      break;
    default:
      if (text.isNotEmpty && isSymbol(value)) {
        if (isSymbol(text.substring(text.length - 1))) {
          setText(
              text.substring(0, text.length - 1) + value); // Replace the symbol
        } else {
          setText(text + value); // Add the value of the button to the text
        }
      } else {
        setText(text + value); // Add the value of the button to the text
      }
  }
}

bool isSymbol(String value) {
  return value == "+" || value == "-" || value == "x" || value == "/";
}

String evaluate(String expression) {
  expression = expression.replaceAll('x', '*'); // Replace 'x' with '*'

  Parser p = Parser();
  Expression exp = p.parse(expression);
  ContextModel cm = ContextModel();
  double eval = exp.evaluate(EvaluationType.REAL, cm);
  return eval.toString();
}