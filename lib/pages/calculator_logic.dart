import 'dart:math';
import 'package:calculator/design/widgets/button_values.dart';
import 'package:math_expressions/math_expressions.dart';

bool isRadians = false;

void handleButtonAction(String value, String text, Function(String) setText) {
  if (text == "Error") {
    setText(
        ""); // Clear the "Error" message before processing the next button press
    return;
  }
  switch (value) {
    case "Град":
      isRadians = !isRadians;
      CalculatorBean.toggleAngleUnitValue();
      break;
    case "Рад":
      isRadians = !isRadians;
      CalculatorBean.toggleAngleUnitValue();
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
          setText(result);
        } else {
          double numberResult = double.parse(result);

          String formattedResult = numberResult.toString();
          if (formattedResult.contains('.')) {
            setText(formattedResult);
          } else {
            int decimalPlaces = formattedResult.split('.')[1].length;

            setText(numberResult.toStringAsFixed(min(decimalPlaces, 14)));
          }
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
    case "ctg":
      setText(text + "ctg(");
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
          setText(text.substring(0, text.length - 1) + value);
        } else {
          setText(text + value);
        }
      } else {
        setText(text + value);
      }
  }
}

bool isSymbol(String value) {
  return value == "+" || value == "-" || value == "x" || value == "/";
}
String evaluate(String expression) {
  expression = replace(expression);

  Parser p = Parser();
  Expression exp = p.parse(expression);
  ContextModel cm = ContextModel();

  double eval = exp.evaluate(EvaluationType.REAL, cm);
  eval = checkCtgValue(eval);

  if (isRadians) {
    if (checkTrigonometricFunctions(expression)) {
      return convertToDegreesMinutesSeconds(eval);
    } else {
      return eval.toString();
    }
  } else {
    return eval.toString();
  }
}

bool checkTrigonometricFunctions(String expression) {
  final RegExp regex = RegExp(r'\barcsin\b|\barccos\b|\barctan\b');
  return regex.hasMatch(expression);
}

String replace(String expression) {
  expression = expression.replaceAll('x', '*');
  expression = expression.replaceAll('pi', pi.toString());
  expression = expression.replaceAll('ctg', '1/tan');
  if (isRadians) {
    expression = expression.replaceAllMapped(RegExp(r'(sin|cos|tan)\(([^)]+)\)'), (match) {
      String? trigFunction = match.group(1); // sin, cos, or tan
      double? valueInParentheses = double.tryParse(match.group(2) ?? '');
      if (trigFunction != null && valueInParentheses != null) {
        double degreesValue = valueInParentheses * (pi / 180);
        return '$trigFunction($degreesValue)';
      }
      return match.group(0) ?? '';
    });
  }
  return expression;
}

double checkCtgValue(double eval) {
  if (eval.toString().contains('1/tan')) {
    if (eval < 0.000000000000001) {
      return 0;
    } else {
      String evalStr = eval.toStringAsFixed(10);
      int firstZeroIndex = evalStr.indexOf('0', evalStr.indexOf('.') + 1);
      if (firstZeroIndex != -1) {
        evalStr = evalStr.substring(0, firstZeroIndex);
      }
      return double.parse(evalStr);
    }
  } else {
    return eval;
  }
}

String convertToDegreesMinutesSeconds(double eval) {
  double degrees = eval * (180.0 / pi);
  int deg = degrees.truncate();
  double minutesDouble = (degrees.abs() - deg.abs()) * 60.0;
  int min = minutesDouble.truncate();
  double secondsDouble = (minutesDouble - min) * 60.0;
  return '${deg.toString()}° ${min.toString().padLeft(2, '0')}\' ${secondsDouble.toStringAsFixed(2)}\"';
}
