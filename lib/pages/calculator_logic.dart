import 'dart:math';

import 'package:math_expressions/math_expressions.dart';
bool isRadians = false;
void handleButtonAction(String value, String text, Function(String) setText){

  switch (value) {
    case "RAD/DEG":
      if (isRadians) {
        isRadians = !isRadians;

      } else {
        isRadians = !isRadians;
        setText(text.replaceAll("deg", "rad"));
      }
      break;
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
        String result = evaluate(text);
        if (result.contains('°') && result.contains('\'')) {
          // Если результат содержит градусы и минуты, выводим его как есть
          setText(result);
        } else {
          // Если результат не содержит градусы и минуты, преобразуем его в число
          double numberResult = double.parse(result);
          String formattedResult = numberResult.toString();
          if (formattedResult.contains('.')) {
            // Если есть точка, выводим цифры после нее
            setText(formattedResult);
          } else {
            // Если нет точки, выводим столько знаков, сколько есть после запятой, но не больше 15
            int decimalPlaces = formattedResult.split('.')[1].length;
            decimalPlaces = min(decimalPlaces, 15);
            setText(numberResult.toStringAsFixed(decimalPlaces));
          }
        }
      } catch (e) {
        setText("Error"); // Display an error message if the expression is invalid
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
    case "π":
      setText(text + "pi");
      break;
    case "arctan":
      setText(text + "arctan(");
      break;
    case "arcsin":
      setText(text + "arcsin(");
      break;
    case "arccos":
      setText(text + "arccos(");
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
  expression = expression.replaceAll('x', '*');

  Parser p = Parser();
  Expression exp = p.parse(expression);
  ContextModel cm = ContextModel();
  double eval = exp.evaluate(EvaluationType.REAL, cm);

  if (isRadians) {
    // Преобразуем радианы в градусы
    double degrees = eval * (180.0 / pi);
    // Разделяем градусы на целое и дробное значение
    int deg = degrees.truncate();
    double minutesDouble = (degrees.abs() - deg.abs()) * 60.0;
    // Разделяем минуты на целое и дробное значение
    int min = minutesDouble.truncate();
    double secondsDouble = (minutesDouble - min) * 60.0;

    // Форматируем результат в виде строки с градусами, минутами и секундами
    String result = '${deg.toString()}° ${min.toString().padLeft(2, '0')}\' ${secondsDouble.toStringAsFixed(2)}\"';
    return result;
  } else {
    // Если результат уже в градусах, просто возвращаем его
    return eval.toString();
  }
}
