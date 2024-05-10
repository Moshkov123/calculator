import 'dart:math';
import 'package:calculator/pages/button_logic.dart';
import 'package:math_expressions/math_expressions.dart';



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

  if (isRadians &&checkTrigonometricFunctions(expression)) {
      return convertToDegreesMinutesSeconds(eval);
    }
   else {
    return eval.toString();
  }
}
bool checkFunctions(String expression) {
  final RegExp regex = RegExp(r'\bsin\b|\bcos\b|\btan\b');
  return regex.hasMatch(expression);
}
bool checkTrigonometricFunctions(String expression) {
  final RegExp regex = RegExp(r'\barcsin\b|\barccos\b|\barctan\b');
  return regex.hasMatch(expression);
}
String replace(String expression) {
  expression = expression.replaceAll('x', '*');
  expression = expression.replaceAll('pi', pi.toString());

  if (isRadians && checkFunctions(expression)) {
    expression = expression.replaceAllMapped(RegExp(r'(sin|cos|tan)\(([^)]+)\)'), (match) {
      String? trigFunction = match.group(1);
      double? valueInParentheses = double.tryParse(match.group(2) ?? '');
      if (trigFunction != null && valueInParentheses != null) {
        double degreesValue = valueInParentheses * (pi / 180);
        return '$trigFunction($degreesValue)';
      }
      return match.group(0) ?? '';
    });
  }
  expression = expression.replaceAllMapped(RegExp(r'ctg\(([^)]+)\)'), (match) {
    double? valueInParentheses = double.tryParse(match.group(1) ?? '');
    if (valueInParentheses != null) {
      double degreesValue = valueInParentheses * (pi / 180);
      return '1/tan($degreesValue)';
    }
    return match.group(0) ?? '';
  });
  return expression;
}

double checkCtgValue(double eval){
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
String convertToDegreesMinutesSeconds(double radians) {
  double degrees = radians * (180 / pi);
  int deg = degrees.toInt();
  double minutesDouble = (degrees - deg) * 60;
  int min = minutesDouble.toInt();
  double seconds = (minutesDouble - min) * 60;
  return '${deg}° ${min.toString().padLeft(2, '0')}\' ${seconds.toStringAsFixed(2)}\"';
}
